//
//  PhotoViewController.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 11.09.2022.
//

import UIKit

class PhotoViewController: UICollectionViewController, UISearchBarDelegate {
    
    var networkDataFetcher = DataFetcher()
    
    private let cellId = "cellId"
    
    private var previousSearchQuery: Set<String> = UserDefaults.standard.savedSearchQuery()
    
    private var pictures = [PhotoResult]()
    
    private var likedPictures = UserDefaults.standard.likedPictures()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var timer: Timer?
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.tabBarItemAccent]
        let attributedTitle = NSAttributedString(string: "Refreshing...", attributes: attributes)
        rc.tintColor = UIColor.tabBarItemAccent
        rc.attributedTitle = attributedTitle
        rc.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        return rc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        refreshingRandomSearchRequest()
        setupCollectionView()
    }
    
    @objc private func handlePullToRefresh(sender: UIRefreshControl) {
        refreshingRandomSearchRequest()
        sender.endRefreshing()
    }
    
    private func refreshingRandomSearchRequest() {
        searchBar(searchController.searchBar, textDidChange: self.previousSearchQuery.randomElement() ?? "")
    }
    
    // MARK: - Setup SearchBar and CollectionView
    
    private func setupCollectionView() {
        collectionView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.refreshControl = self.refreshControl
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.searchController?.searchBar.tintColor = UIColor.tabBarItemAccent
        navigationItem.hidesSearchBarWhenScrolling = true
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            searchBar.autocorrectionType = .yes
            
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchResult) in
                
                if searchResult?.results.count != 0 {
                    do {
                        var listOfSearchQuery = UserDefaults.standard.savedSearchQuery()
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
                    self?.collectionView.reloadData()
                }
            }
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = DetailViewController()
        let picture = self.pictures[indexPath.item]
        detailController.picture = picture
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoViewCell
        let picture = self.pictures[indexPath.item]
        cell.layer.shadowRadius = 6
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowOffset = CGSize(width: 0, height: 4)   
        cell.picture = picture
        return cell
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
