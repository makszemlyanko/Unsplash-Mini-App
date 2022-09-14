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
        
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .clear
        tabBar.shadowImage = UIImage()
        
        setupViewControllers()
        setTabBarAppearance()
        
        #warning("add bottom padding to tabBar")
    }
    
    private func createNavController(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.tintColor = UIColor.tabBarItemAccent
        viewController.navigationItem.title = title
        navController.tabBarItem.image = image
        return navController
    }

    private func setupViewControllers() {
        let photoController = PhotoViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let savedController = SavedViewController(collectionViewLayout: UICollectionViewFlowLayout())

        viewControllers = [
            createNavController(viewController: photoController, title: "Pictures", image: UIImage(systemName: "photo.fill")),
            createNavController(viewController: savedController, title: "Favorites", image: UIImage(systemName: "heart.fill"))
        ]
    }
    
    private func setTabBarAppearance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minY - positionOnY, width: width, height: height), cornerRadius: height / 2)
        
        roundLayer.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .automatic
        
        roundLayer.fillColor = UIColor.mainWhite.cgColor
        
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemLight
        
    }
    
    
}

