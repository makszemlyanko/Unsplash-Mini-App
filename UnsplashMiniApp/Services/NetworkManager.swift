//
//  NetworkManager.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 12.09.2022.
//

import Foundation

final class NetworkManager {
    
    func request(searchTerm: String, complition: @escaping (Data?, Error?) -> Void) {
        let param = self.makeParameters(searchTerm: searchTerm)
        let url = self.makeUrl(params: param)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = makeHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: complition)
        task.resume()
    }
    
    private func makeHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID FC1bNlKCupC2Z8bK8hPHIdTax4Wbr-lW9apVOKdOOQg"
        return headers
    }
    
    private func makeParameters(searchTerm: String?) -> [String: String] {
        var param = [String: String]()
        param["query"] = searchTerm
        param["per_page"] = String(30)
        return param
    }
    
    private func makeUrl(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, _, error) in
            completion(data, error)
        }
    }
}
