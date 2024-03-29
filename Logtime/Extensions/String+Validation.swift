//
//  String+Validation.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 23/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import Foundation

public extension String {
    
    public func isEmail() -> Bool {
        return match(Regex.Email.pattern)
    }
    
    public func isNumber() -> Bool {
        return match(Regex.Number.pattern)
    }
}

public enum Regex: String {
    
    case Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    case Number = "^[0-9]+$"
    
    var pattern: String {
        return rawValue
    }
}

public extension String {
    
    public func match(_ pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count)) != nil
        } catch {
            return false
        }
    }
}
