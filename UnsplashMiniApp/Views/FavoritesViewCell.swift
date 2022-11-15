//
//  FavoritesViewCell.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 20.09.2022.
//

import UIKit
import SDWebImage

class FavoritesViewCell: UICollectionViewCell {
    
    var picture: PhotoResult? {
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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupFavoriteImageView()
    }
    
    private func setupFavoriteImageView() {
        addSubview(favoriteImageView)
        favoriteImageView.translatesAutoresizingMaskIntoConstraints = false
        favoriteImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        favoriteImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        favoriteImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        favoriteImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
