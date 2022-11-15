//
//  PhotoViewCell.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 12.09.2022.
//

import UIKit
import SDWebImage

final class PhotoViewCell: UICollectionViewCell {
    
    static let cellId = "PhotoViewCell"
    
    var picture: Photo? {
        didSet {
            photoActivityIndicator.startAnimating()
            let photoUrl = picture?.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            DispatchQueue.main.async {
                self.photoImageView.sd_setImage(with: url, completed: nil)
                self.authorLabel.text = self.picture?.user?.name
            }
        }
    }
    
    private let photoActivityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView()
        av.color = UIColor.systemGray
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActivityIndicator()
        setupPhotoImageView()
        setupAuthorLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPhotoImageView() {
        addSubview(photoImageView)
        let photoImageViewConstraints = [
            photoImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ]
        NSLayoutConstraint.activate(photoImageViewConstraints)
    }
    
    private func setupActivityIndicator() {
        addSubview(photoActivityIndicator)
        let photoActivityIndicatorConstraints = [
            photoActivityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            photoActivityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ]
        NSLayoutConstraint.activate(photoActivityIndicatorConstraints)
    }
    
    private func setupAuthorLabel() {
        addSubview(authorLabel)
        let authorLabelConstraints = [
            authorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            authorLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            authorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ]
        NSLayoutConstraint.activate(authorLabelConstraints)
    }
}

