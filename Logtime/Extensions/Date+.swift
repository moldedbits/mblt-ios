//
//  Date+.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 23/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import Foundation

extension Date {
    static let dateFormatter = DateFormatter()
    
    static func string(from date: Date?, withFormat format: String = "dd/mm/yy") -> String {
        guard let date = date else { return "" }
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}
