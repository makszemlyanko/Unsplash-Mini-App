//
//  MainTabBarController.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 11.09.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        tabBar.tintColor = .systemRed
    }
    
    private func setupViewControllers() {
        setViewControllers([
            createNavController(viewController: PhotoViewController(), title: "Photos", image: UIImage(systemName: "photo.fill")),
            createNavController(viewController: FavoritesViewController(), title: "Favorites", image: UIImage(systemName: "heart.fill"))
        ], animated: true)
    }
    
    private func createNavController(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.tintColor = .systemRed
        viewController.navigationItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.title = title
        return navController
    }
}
