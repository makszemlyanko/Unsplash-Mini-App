//
//  FavoritesViewController.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 18.09.2022.
//

import UIKit

final class FavoritesViewController: UIViewController {
    
    // MARK: - Properties
    
    private var likedPictures = UserDefaults.standard.getlikedPictures()
    
    private let favoritesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(FavoritesViewCell.self, forCellWithReuseIdentifier: FavoritesViewCell.cellId)
        return collectionView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFavoritesCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        favoritesCollectionView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.likedPictures = UserDefaults.standard.getlikedPictures()
        DispatchQueue.main.async {
            self.favoritesCollectionView.reloadData()
            UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
        }
    }
    
    // MARK: - Collection View Configuration
    
    private func setupFavoritesCollectionView() {
        view.addSubview(favoritesCollectionView)
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
    }
}

// MARK: - Data Source and Delegate Extensions

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.likedPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesViewCell.cellId, for: indexPath) as? FavoritesViewCell else { return UICollectionViewCell() }
        cell.picture = self.likedPictures[indexPath.row]
        return cell
    }
}

extension FavoritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = DetailViewController()
        let picture = self.likedPictures[indexPath.item]
        detailController.picture = picture
        navigationController?.pushViewController(detailController, animated: true)
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
