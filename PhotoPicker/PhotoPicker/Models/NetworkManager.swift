//
//  NetworkManager.swift
//  PhotoPicker
//
//  Created by Эван Крошкин on 27.03.22.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    var networkService = NetworkService()
    
    func fetchImages(searchTerm: String, completion: @escaping (SearchResult?) -> Void) {
        networkService.request(searchTerm: searchTerm) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: SearchResult.self, from: data)
            completion(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}

class NetworkService {
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        let parametrs = prepareParameters(searchTerm: searchTerm)
        let url = url(params: parametrs)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepereHeaders()
        request.httpMethod = "get"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepereHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = Constants.API.key
        return headers
    }
    
    private func prepareParameters(searchTerm: String?) -> [String: String] {
        var parametrs = [String: String]()
        parametrs["query"] = searchTerm
        parametrs["page"] = "1"
        parametrs["per_page"] = String(30)
        return parametrs
    }
    
    private func url(params: [String: String]) -> URL {
        var componets = URLComponents()
        componets.scheme = "https"
        componets.host = "api.unsplash.com"
        componets.path = "/search/photos"
        componets.queryItems = params.map{URLQueryItem(name: $0, value: $1)}
        return componets.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
