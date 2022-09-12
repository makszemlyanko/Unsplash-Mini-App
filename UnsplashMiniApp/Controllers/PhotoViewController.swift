//
//  PhotoViewController.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 11.09.2022.
//

import UIKit

class PhotoViewController: UICollectionViewController, UISearchBarDelegate {
    
    private let cellId = "cellId"
    
    var networkDataFetcher = DataFetcher()
    
    private var pictures = [PhotoResult]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        searchBar(searchController.searchBar, textDidChange: "Ted")
        
        setupCollectionView()
        
        
    }
    
    // MARK: - Setup SearchBar and CollectionView
    
    private func setupCollectionView() {
        collectionView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        collectionView.register(PhotoViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.searchController?.searchBar.tintColor = UIColor.tabBarItemAccent
        navigationController?.navigationBar.tintColor = UIColor.tabBarItemAccent; #warning ("doesnt work")
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.networkDataFetcher.fetchImages(searchTerm: searchText) { [weak self] (searchRes) in
                guard let fetchedPhotos = searchRes else { return }
                self?.pictures = fetchedPhotos.results
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        })
    }
    
    // MARK: - UICollectionView Delegate and DataSource methods
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = DetailViewController()
        let picture = self.pictures[indexPath.item]
        detailController.picture = picture
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoViewCell
        let picture = pictures[indexPath.item]
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
