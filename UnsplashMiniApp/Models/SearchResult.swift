//
//  SearchResult.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 12.09.2022.
//

import Foundation

enum UrlKind: String {
    case raw
    case full
    case regular
    case small
    case thumb
}

struct SearchResult: Codable {
    let results: [Photo]
}

struct Photo: Codable {
    let urls: [UrlKind.RawValue: String]
    var user: User?
    let downloads: Int?
}
    
struct User: Codable {
    var username: String?
    var name: String?
    var totalPhotos: Int?
}
