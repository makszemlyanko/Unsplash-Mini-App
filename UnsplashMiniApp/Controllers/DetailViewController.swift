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
    
    private var likedPictures = UserDefaults.standard.likedPictures()
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        view.addSubview(imageView)
        setupImageViewLayout()
        setupNavBarButtons()
    }
    
    private func setupImageViewLayout() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupNavBarButtons() {
        
        let likedPictures = UserDefaults.standard.likedPictures()
        
        let hasLikedPicture = likedPictures.firstIndex(where: {$0.urls == self.picture?.urls}) != nil
        
        if hasLikedPicture {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(handleDeleteFromFavorites))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(handleSaveToFavorites))
        }
    
    }
    
    @objc private func handleSaveToFavorites() {
        guard let picture = self.picture else { return }
        
        do {
            var listOfPictures = UserDefaults.standard.likedPictures()
            listOfPictures.append(picture)
            let picturesData = try JSONEncoder().encode(listOfPictures)
            UserDefaults.standard.setValue(picturesData, forKey: UserDefaults.likedPicturesKey)
            let alertController = UIAlertController(title: "Saved", message: "This picture has been saved to favorites", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        } catch {
            print("Failed to save picture to UserDefaults :", error)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(handleDeleteFromFavorites))
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
    }
    

    
    
    
}
