//
//  Project.swift
//  Logtime
//
//  Created by Amit kumar Swami on 21/04/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import Foundation
import ObjectMapper

struct Project: Mappable {
    var id: Int!
    var name: String!
    var projectDetails: String?
    var active: Bool!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        projectDetails <- map["project_detail"]
        active <- map["active"]
    }
    
}
