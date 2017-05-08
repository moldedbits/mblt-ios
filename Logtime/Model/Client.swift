//
//  Client.swift
//  Logtime
//
//  Created by Amit kumar Swami on 21/04/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import Foundation
import ObjectMapper

struct Client: Mappable {
    var id: Int!
    var name: String!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        if map.mappingType == .fromJSON {
            id <- map["id"]
        }
        
        name <- map["name"]
    }
}
