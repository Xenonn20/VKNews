//
//  UserResponse.swift
//  VKNews
//
//  Created by Кирилл Медведев on 31.10.2019.
//  Copyright © 2019 Kirill Medvedev. All rights reserved.
//

import Foundation

struct UserResponseWrapped: Decodable {
    let response: [UserResponse]
}

struct UserResponse: Decodable {
    let photo100: String?
    let firstName: String?
    let lastName: String?
}
