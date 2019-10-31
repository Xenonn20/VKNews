//
//  API.swift
//  VKNews
//
//  Created by Кирилл Медведев on 24.10.2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import Foundation

struct API {
    
    static let scheme = "https"
    static let host = "api.vk.com"
    static let version = "5.102"
    
    static let newsFeed = "/method/newsfeed.get"
    static let user = "/method/users.get"
}
