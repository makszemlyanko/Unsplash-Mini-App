//
//  SearchResult.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 12.09.2022.
//

import Foundation

struct SearchResult: Codable {
    let total: Int
    let results: [PhotoResult]
}

struct PhotoResult: Codable {
    let width: Int
    let height: Int
    let urls: [UrlKind.RawValue: String]
    
    enum UrlKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
