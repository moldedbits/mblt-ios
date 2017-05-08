//
//  Timesheet.swift
//  Logtime
//
//  Created by Amit kumar Swami on 21/04/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import Foundation
import ObjectMapper

struct Timesheet: Mappable {
    var id: Int!
    var hours: Int!
    var date: Date!
    var standupDetails: String?
    var userId: Int!
    var workedFromHome: Bool!
    var project: Project!
    var url: URL!
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        if map.mappingType == .fromJSON {
            id <- map["id"]
            userId <- map["user_id"]
            url <- (map["url"], URLTransform())
        }
        
        hours <- map["hours"]
        date <- (map["date"], DateTransform())
        standupDetails <- map["standup_detail"]
        workedFromHome <- map["worked_from_home"]
        project <- map["project"]
    }
}
