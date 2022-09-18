//
//  UserDefaults.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 14.09.2022.
//

import Foundation

extension UserDefaults {
    
    static let likedPicturesKey = "likedPicturesKey"
    
    static let previousSearchQueryKey = "savedSearchQueryKey"
    
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
    
    func savedSearchQuery() -> Set<String> {
        guard let savedQueryData = UserDefaults.standard.data(forKey: UserDefaults.previousSearchQueryKey) else { return Set<String>() }
        
        do {
            guard let searchQuery = try JSONDecoder().decode(Set<String>?.self, from: savedQueryData) else { return Set<String>() }
            return searchQuery
        } catch {
            print("Failed to get previous search query: ", error)
        }
        return savedSearchQuery()
    }
}


