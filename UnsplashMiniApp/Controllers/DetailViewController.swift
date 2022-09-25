//
//  DetailViewController.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 12.09.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var picture: PhotoResult? {
        didSet {
            let photoUrl = picture?.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            imageView.sd_setImage(with: url, completed: nil)
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    private lazy var likedBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(handleDeleteFromFavorites))
    }()
    
    private lazy var notLikedBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(handleSaveToFavorites))
    }()
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleSaveToLocalLibrary))
    }()
    
    private var likedPictures = UserDefaults.standard.likedPictures()
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        view.addSubview(imageView)
        setupImageViewLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarButtons()
    }
        
    private func setupImageViewLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupNavBarButtons() {
        let likedPictures = UserDefaults.standard.likedPictures()
        let hasLikedPicture = likedPictures.firstIndex(where: {$0.urls == self.picture?.urls}) != nil
        navigationItem.rightBarButtonItems = [ hasLikedPicture ? likedBarButtonItem : notLikedBarButtonItem, saveBarButtonItem]
    }
    
    @objc private func handleSaveToFavorites() {
        guard let picture = self.picture else { return }
        
        do {
            var listOfPictures = UserDefaults.standard.likedPictures()
            listOfPictures.append(picture)
            let picturesData = try JSONEncoder().encode(listOfPictures)
            UserDefaults.standard.setValue(picturesData, forKey: UserDefaults.likedPicturesKey)
        } catch {
            print("Failed to save picture to UserDefaults :", error)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(handleDeleteFromFavorites))
        
        showNewFavoriteBadge()
    }
    
    @objc private func showNewFavoriteBadge() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }
    
    @objc private func handleDeleteFromFavorites() {
        guard let picture = self.picture else { return }
        
        let alertController = UIAlertController(title: "Remove Picture", message: "Remove this picture from Favorites?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { (_) in
            UserDefaults.standard.deletePicture(picture: picture)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(self.handleSaveToFavorites))
            self.navigationController?.popViewController(animated: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
        
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil
    }
    
    @objc private func handleSaveToLocalLibrary() {
        let alerController = UIAlertController(title: "Save image?", message: "Save image to device?", preferredStyle: .alert)
        alerController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            guard let imageToSave = self.imageView.image else { return }
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
            let alert = UIAlertController(title: "Saved", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }))
        alerController.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
        present(alerController, animated: true, completion: nil)
    }
}
