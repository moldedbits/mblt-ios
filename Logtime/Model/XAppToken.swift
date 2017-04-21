//
//  XAppToken.swift
//  Logtime
//
//  Created by Amit kumar Swami on 20/04/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import Foundation

struct XAppToken {
    enum DefaultsKeys: String {
        case TokenKey = "TokenKey"
        case TokenMail = "TokenMail"
    }
    
    // MARK: - Initializers
    let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    init() {
        self.defaults = UserDefaults.standard
    }
    
    
    // MARK: - Properties
    
    var token: String? {
        get {
            let key = defaults.string(forKey: DefaultsKeys.TokenKey.rawValue)
            return key
        }
        set(newToken) {
            defaults.set(newToken, forKey: DefaultsKeys.TokenKey.rawValue)
        }
    }
    
    var mail: String? {
        get {
            return defaults.object(forKey: DefaultsKeys.TokenMail.rawValue) as? String
        }
        set(newMail) {
            defaults.set(newMail, forKey: DefaultsKeys.TokenMail.rawValue)
        }
    }
    
    var isValid: Bool {
        if let token = token, let mail = mail {
            return !token.isEmpty && !mail.isEmpty
        }
        
        return false
    }
}
