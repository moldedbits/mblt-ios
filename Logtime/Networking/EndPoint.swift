//
//  EndPoint.swift
//  Logtime
//
//  Created by Amit kumar Swami on 19/04/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import Foundation
import Moya

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

enum LogtimeAPI {
    case authenticate(username: String, password: String)
    
}

extension LogtimeAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL { return URL(string: "https://try-mblt.herokuapp.com")! }
    var path: String {
        switch self {
        case .authenticate(_, _):
            return "/users/sign_in.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .authenticate(_, _):
            return .post
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .authenticate(let username, let password):
            let emailPassword = ["email": username, "password": password]
            return ["user": emailPassword]
        }
    }
    
    var shouldAuthorize: Bool {
        switch self {
        case .authenticate(_, _):
            return false
        }
    }
    
    var parameterEncoding: Moya.ParameterEncoding { return JSONEncoding.default }
    
    var task: Task {
        return .request
    }
    
    var sampleData: Data {
        switch self {
        case .authenticate(_, _):
            return "{\"user\":{\"id\":3,\"email\":\"x@x.com\",\"created_at\":\"2016-03-29T11:55:30.730Z\",\"updated_at\":\"2017-04-20T10:05:36.009Z\",\"name\":\"x\",\"authentication_token\":\"BihtsuRtzzD59RVxYNVM\",\"account_active\":true},\"status\":\"ok\",\"authentication_token\":\"BihtsuRtzzD59RVxYNVM\"}".data(using: .utf8)!
        }
    }
}

public struct LogtimeAccessTokenPlugin: PluginType {
    public let token: String
    public let username: String
    
    init(token: String, username: String) {
        self.token = token
        self.username = username
    }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let authorizable = target as? AccessTokenAuthorizable, authorizable.shouldAuthorize == false {
            return request
        }
        
        var request = request
        request.addValue(token, forHTTPHeaderField: "X-User-Token")
        request.addValue(username, forHTTPHeaderField: "X-User-Email")
        
        return request
    }
    
}
