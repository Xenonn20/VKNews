//
//  NetworkDataFetcher.swift
//  VKNews
//
//  Created by Кирилл Медведев on 25.10.2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func getFeed(response: @escaping (FeedResponse?) -> Void)
    func getUser(response: @escaping (UserResponse?) -> Void)
}

struct NetworkDataFetcher: DataFetcher {
    
    private var authService: AuthService
    let networking: Networking
    
    
    init(networking: Networking, authService: AuthService = AppDelegate.shared().authService) {
        self.networking = networking
        self.authService = authService
    }
    
    func getFeed(response: @escaping (FeedResponse?) -> Void) {
        let param = ["filters": "post, photo"]
        networking.request(path: API.newsFeed, params: param) { (data, error) in
            if let error = error { print("Error: \(error.localizedDescription)"); response(nil)}
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            response(decoded?.response)
        }
    }
    func getUser(response: @escaping (UserResponse?) -> Void) {
        guard let userId = authService.userId else { return }
        let param = ["user_ids": "\(userId), first_name, last_name", "fields": "photo_100"]
        networking.request(path: API.user, params: param) { (data, error) in
            if let error = error { print("Error: \(error.localizedDescription)"); response(nil)}
            
            let decoded = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            response(decoded?.response.first)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
    
}
