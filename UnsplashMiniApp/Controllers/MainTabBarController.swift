//
//  MainTabBarController.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 11.09.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        tabBar.tintColor = .label
    }
    
    private func createNavController(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.tintColor = .label
        viewController.navigationItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.title = title
        return navController
    }

    private func setupViewControllers() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let photoController = PhotoViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let favoritesController = FavoritesViewController(collectionViewLayout: layout)
        
        viewControllers = [
            createNavController(viewController: photoController, title: "Pictures", image: UIImage(systemName: "photo.fill")),
            createNavController(viewController: favoritesController, title: "Favorites", image: UIImage(systemName: "heart.fill"))
        ]
    }
    
}

