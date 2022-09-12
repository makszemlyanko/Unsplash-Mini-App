//
//  DetailViewController.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 12.09.2022.
//

import UIKit

class DetailViewController: UIViewController {
    
    var picture: PhotoResult! {
        didSet {
            let photoUrl = picture.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
            imageView.sd_setImage(with: url, completed: nil)
            imageView.contentMode = .scaleAspectFit
        }
    }
    
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        view.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
    
    
    
}
