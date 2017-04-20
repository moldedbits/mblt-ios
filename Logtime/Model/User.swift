//
//  User.swift
//  Logtime
//
//  Created by Amit kumar Swami on 20/04/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import Foundation
import ObjectMapper

struct User: Mappable {
    
    var id: Int!
    var email: String!
    var name: String!
    var authToken: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        email <- map["email"]
        name <- map["name"]
        authToken <- map["authentication_token"]
    }
}

struct AuthResponse: Mappable {
    
    var user: User!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        user <- map["user"]
    }
}
