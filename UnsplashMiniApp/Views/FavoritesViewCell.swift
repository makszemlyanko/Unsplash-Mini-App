//
//  FavoritesViewCell.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 20.09.2022.
//

import UIKit
import SDWebImage

final class FavoritesViewCell: UICollectionViewCell {
    
    static let cellId = "FavoritesViewCell"
    
    var picture: Photo? {
        didSet {
            let photoUrl = picture?.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            DispatchQueue.main.async {
                self.favoriteImageView.sd_setImage(with: url, completed: nil)
            }
        }
    }
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureFavoriteImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureFavoriteImageView() {
        addSubview(favoriteImageView)
        let favoriteImageViewConstraints = [
            favoriteImageView.topAnchor.constraint(equalTo: self.topAnchor),
            favoriteImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            favoriteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            favoriteImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ]
        NSLayoutConstraint.activate(favoriteImageViewConstraints)
    }
}
