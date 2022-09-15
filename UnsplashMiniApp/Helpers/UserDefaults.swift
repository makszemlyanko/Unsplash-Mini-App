//
//  UserDefaults.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 14.09.2022.
//

import Foundation

extension UserDefaults {
    
    static let likedPicturesKey = "likedPicturesKey"
    
    static let savedSearchQueryKey = "savedSearchQueryKey"
    
    func likedPictures() -> [PhotoResult] {
        guard let likedPicturesData = UserDefaults.standard.data(forKey: UserDefaults.likedPicturesKey) else { return [] }
        
        do {
            guard let likedPictures = try JSONDecoder().decode([PhotoResult]?.self, from: likedPicturesData) else { return [] }
            return likedPictures
        } catch {
            print("Failed to fetch data from UserDefaults: ", error)
        }
        
        return likedPictures()
    }
    
    func deletePicture(picture: PhotoResult){
        let pictures = likedPictures()
        let filterPictures = pictures.filter { (pic) -> Bool in
            pic.urls != picture.urls
        }
        
        do {
            let data = try JSONEncoder().encode(filterPictures)
            UserDefaults.standard.setValue(data, forKey: UserDefaults.likedPicturesKey)
        } catch {
            print("Failed to delete picture from UserDefaults: ", error)
        }
    }
    
}

