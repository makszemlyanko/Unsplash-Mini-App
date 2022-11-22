//
//  DetailViewController.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 12.09.2022.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var picture: Photo? {
        didSet {
            let photoUrl = picture?.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            DispatchQueue.main.async {
                self.imageView.sd_setImage(with: url, completed: nil)
                self.authorLabel.text = self.picture?.user?.name
                self.locationLabel.text = self.picture?.user?.username
                self.totalPhotosLabel.text = "Total photos: \(String(describing: self.picture?.user?.totalPhotos ?? 0))"
            }
        }
    }
    
    private var likedPictures = UserDefaults.standard.getlikedPictures()
    
    private lazy var likedBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "heart.fill"), style: .plain, target: self, action: #selector(handleDeleteFromFavorites))
    }()
    
    private lazy var notLikedBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(handleSaveToFavorites))
    }()
    
    private lazy var saveBarButtonItem: UIBarButtonItem = {
        UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleSaveToLocalLibrary))
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private let totalPhotosLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        return stack
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureImageView()
        configureStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBarButtons()
    }
    
    //MARK: - Views Configuration
    
    private func configureImageView() {
        view.addSubview(imageView)
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 400)
        ]
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    private func configureStackView() {
        view.addSubview(stackView)
        let stackViewConstraints = [
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            stackView.widthAnchor.constraint(equalToConstant: 400),
            stackView.heightAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(stackViewConstraints)
        
        stackView.addArrangedSubview(authorLabel)
        stackView.addArrangedSubview(locationLabel)
        stackView.addArrangedSubview(totalPhotosLabel)
    }
    
    // MARK: - NavBar Buttons and TabBar Badge Logic
    
    private func setupNavBarButtons() {
        let likedPictures = UserDefaults.standard.getlikedPictures()
        let hasLikedPicture = likedPictures.firstIndex(where: {$0.urls == self.picture?.urls}) != nil
        navigationItem.rightBarButtonItems = [ hasLikedPicture ? likedBarButtonItem : notLikedBarButtonItem, saveBarButtonItem]
    }
    
    @objc private func handleSaveToFavorites() {
        guard let picture = self.picture else { return }
        do {
            var listOfPictures = UserDefaults.standard.getlikedPictures()
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
        let alertController = UIAlertController(title: "Remove Photo", message: "Remove this photo from Favorites?", preferredStyle: .actionSheet)
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
        let alerController = UIAlertController(title: "Save photo?", message: "Save photo to device?", preferredStyle: .alert)
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
