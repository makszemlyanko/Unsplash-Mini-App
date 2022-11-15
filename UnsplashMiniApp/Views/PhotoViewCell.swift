//
//  PhotoViewCell.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 12.09.2022.
//

import UIKit
import SDWebImage

class PhotoViewCell: UICollectionViewCell {
    
    var picture: PhotoResult? {
        didSet {
            spinner.startAnimating()
            let photoUrl = picture?.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            DispatchQueue.main.async {
                self.photoImageView.sd_setImage(with: url, completed: nil)
                self.authorLabel.text = self.picture?.user?.name
            }
        }
    }

    private let spinner = UIActivityIndicatorView()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
     private let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSpiner()
        setupPhotoImageView()
        setupAuthorLabel()
    }
    
    private func setupPhotoImageView() {
        addSubview(photoImageView)
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    private func setupSpiner() {
        addSubview(spinner)
        spinner.color = UIColor.label
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupAuthorLabel() {
        addSubview(authorLabel)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        authorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        authorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

