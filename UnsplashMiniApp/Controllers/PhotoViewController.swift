//
//  PhotoViewController.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 11.09.2022.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    // MARK: - Properties
    
    private var networkDataFetcher = DataFetcher()
    
    private var pictures = [Photo]()
    
    private var previousSearchQuery: Set<String> = UserDefaults.standard.getSavedSearchQuery()
    
    private var likedPictures = UserDefaults.standard.getlikedPictures()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var timer: Timer?
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.systemGray]
        let attributedTitle = NSAttributedString(string: "Refreshing...", attributes: attributes)
        rc.tintColor = UIColor.systemGray
        rc.attributedTitle = attributedTitle
        rc.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        return rc
    }()
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: PhotoViewCell.cellId)
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        refreshingRandomSearchRequest()
        setupPhotoCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        photoCollectionView.frame = view.bounds
    }
    
    // MARK: - Collection View Configuration
    
    private func setupPhotoCollectionView() {
        view.addSubview(photoCollectionView)
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.refreshControl = self.refreshControl
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.searchController?.searchBar.tintColor = UIColor.systemRed
        navigationItem.hidesSearchBarWhenScrolling = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
    }
    
    @objc private func handlePullToRefresh(sender: UIRefreshControl) {
        refreshingRandomSearchRequest()
        sender.endRefreshing()
    }
    
    private func refreshingRandomSearchRequest() {
        searchBar(searchController.searchBar, textDidChange: self.previousSearchQuery.randomElement() ?? "")
    }
}

// MARK: - Data Source and Delegate Extensions

extension PhotoViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoViewCell.cellId, for: indexPath) as? PhotoViewCell else { return UICollectionViewCell() }
        let picture = self.pictures[indexPath.item]
        cell.picture = picture
        return cell
    }
}

extension PhotoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = DetailViewController()
        let picture = self.pictures[indexPath.item]
        detailController.picture = picture
        navigationController?.pushViewController(detailController, animated: true)
    }
}

extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3 * 16) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}

extension PhotoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            searchBar.autocorrectionType = .yes
            self.networkDataFetcher.fetchPhotos(searchTerm: searchText) { [weak self] (searchResult) in
                if searchResult?.results.count != 0 {
                    do {
                        var listOfSearchQuery = UserDefaults.standard.getSavedSearchQuery()
                        listOfSearchQuery.insert(searchText)
                        let searchQuaeryData = try JSONEncoder().encode(listOfSearchQuery)
                        UserDefaults.standard.setValue(searchQuaeryData, forKey: UserDefaults.previousSearchQueryKey)
                    } catch {
                        print("Failed to save data to UserDefaults: ", error)
                    }
                }
                guard let searchResult = searchResult else { return }
                self?.pictures = searchResult.results
                DispatchQueue.main.async {
                    self?.photoCollectionView.reloadData()
                }
            }
        })
    }
}
