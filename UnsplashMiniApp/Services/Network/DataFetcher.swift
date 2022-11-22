//
//  DataFetcher.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 12.09.2022.
//

import Foundation

final class DataFetcher {
    
    var networkService = NetworkManager()
    
    func fetchPhotos(searchTerm: String, complition: @escaping (SearchResult?) -> ()) {
        networkService.request(searchTerm: searchTerm) { (data, error) in
            if let error = error {
                print("Failed to fetch photos: ", error.localizedDescription)
                complition(nil)
            }
            let decode = self.decodeJSON(type: SearchResult.self, from: data)
            complition(decode)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch {
            print("Failed to decode json; ", error)
            return nil
        }
    }
}
