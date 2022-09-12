//
//  NetworkManager.swift
//  UnsplashMiniApp
//
//  Created by Maks Kokos on 12.09.2022.
//

import Foundation

class NetworkManager {
    
    func request(searchTerm: String, complition: @escaping (Data?, Error?) -> Void) {
        let param = self.prepareParam(searchTerm: searchTerm)
        let url = self.url(params: param)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "get"
        let task = createDataTask(from: request, complition: complition)
        task.resume()
    }
    
    private func prepareHeader() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID FC1bNlKCupC2Z8bK8hPHIdTax4Wbr-lW9apVOKdOOQg"
        return headers
    }
    
    private func prepareParam(searchTerm: String?) -> [String: String] {
        var param = [String: String]()
        param["query"] = searchTerm
        param["page"] = String(1)
        param["per_page"] = String(50)
        return param
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1)}
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { (data, resp, err) in
            complition(data, err)
        }
    }
}