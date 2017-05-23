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
    var date: Date?
    var standupDetails: String?
    var userId: Int!
    var workedFromHome: Bool!
    var project: Project!
    var url: URL!
    var projectId: Int?
    
    init() {
        self.date = Date()
        self.hours = 0
    }
    
    init(hours: Int, date: Date, standupDetails: String?, workedFromHome: Bool, projectId: Int) {
        self.hours = hours
        self.date = date
        self.standupDetails = standupDetails
        self.projectId = projectId
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        if map.mappingType == .fromJSON {
            id <- map["id"]
            userId <- map["user_id"]
            url <- (map["url"], URLTransform())
            project <- map["project"]
        }

        hours <- map["hours"]
        date <- (map["date"], dateTransform)
        standupDetails <- map["standup_detail"]
        workedFromHome <- map["worked_from_home"]
        projectId <- map["project_id"]
    }
}

let dateTransform = TransformOf<Date, String>(fromJSON: { (value: String?) -> Date? in
    guard let dateString = value else { return nil }
    return Date.logtimeDate(from: dateString)
}, toJSON: { (value: Date?) -> String? in
    return Date.logtimeDateString(from: value)
})


extension Date {
    
    static func logtimeDateString(from date: Date?) -> String? {
        guard let date = date else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    static func logtimeDate(from dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: dateString)
    }
}
