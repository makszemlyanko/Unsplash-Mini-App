//
//  FavoritesViewController.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 18.09.2022.
//

import UIKit

class FavoritesViewController: UICollectionViewController {
    
    private let cellId = "cellId"
    
    private var likedPictures = UserDefaults.standard.likedPictures()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.likedPictures = UserDefaults.standard.likedPictures()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
        }
    }
    
    // MARK: - Setup CollectionView
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FavoritesViewCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = DetailViewController()
        let picture = self.likedPictures[indexPath.item]
        detailController.picture = picture
        navigationController?.pushViewController(detailController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.likedPictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoritesViewCell
        cell.picture = self.likedPictures[indexPath.row]
        return cell
    }

}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width / 3
       return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
        
}

