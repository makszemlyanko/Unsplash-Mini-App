//
//  SearchResult.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 12.09.2022.
//

import Foundation

struct SearchResult: Codable {
    let results: [PhotoResult]
}



struct PhotoResult: Codable {
    
    enum UrlKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
    let urls: [UrlKind.RawValue: String]
    var user: User?
    let downloads: Int?
}
    

struct User: Codable {
    var username: String?
    var name: String?
    var total_photos: Int?
}

