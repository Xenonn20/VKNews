//
//  NetworkService.swift
//  VKNews
//
//  Created by Кирилл Медведев on 24.10.2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import Foundation

protocol Networking {
    func request(path: String, params: [String: String], complition: @escaping (Data?, Error?) -> Void)
}

final class NetworkService: Networking {
    
    private var authService: AuthService
    
    init(authService: AuthService = AppDelegate.shared().authService) {
        self.authService = authService
    }
    
    func request(path: String, params: [String : String], complition: @escaping (Data?, Error?) -> Void) {
        guard let token = authService.token else { return }
        
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version
        let url = self.url(from: path, param: allParams)
        let request = URLRequest(url: url)
        let task = createDataTask(from: request, complition: complition)
        task.resume()
        print(url)
    }
    
    private func createDataTask(from request: URLRequest, complition: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask{
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                complition(data, error)
            }
        }
    }
    
    private func url(from path: String, param: [String: String]) -> URL {
        var components = URLComponents()
        
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = param.map { URLQueryItem(name: $0, value: $1)}
        
        return components.url!
    }
}
