//
//  EndPoint.swift
//  Logtime
//
//  Created by Amit kumar Swami on 19/04/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

enum LogtimeAPI {
    case authenticate(username: String, password: String)
    case timesheets
    
}

extension LogtimeAPI: TargetType, AccessTokenAuthorizable {
    var baseURL: URL { return URL(string: "https://try-mblt.herokuapp.com")! }
    var path: String {
        switch self {
        case .authenticate(_, _):
            return "/users/sign_in.json"
        case .timesheets:
            return "/timesheets.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .authenticate(_, _):
            return .post
        case .timesheets:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .authenticate(let username, let password):
            let emailPassword = ["email": username, "password": password]
            return ["user": emailPassword]
        case .timesheets:
            return nil
        }
    }
    
    var shouldAuthorize: Bool {
        switch self {
        case .authenticate(_, _):
            return false
        default:
            return true
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
        default:
            return "".data(using: .utf8)!
        }
    }
}

public struct LogtimeAccessTokenPlugin: PluginType {
    let token: XAppToken
    
    init(token: XAppToken) {
        self.token = token
    }
    
    init() {
        self.token = XAppToken()
    }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let authorizable = target as? AccessTokenAuthorizable, authorizable.shouldAuthorize == false {
            return request
        }
        
        var request = request
        guard token.isValid else { return request }
        request.addValue(token.token ?? "", forHTTPHeaderField: "X-User-Token")
        request.addValue(token.mail ?? "", forHTTPHeaderField: "X-User-Email")
        
        return request
    }
    
}

class LogtimeProvider<Target>: RxMoyaProvider<Target> where Target: TargetType {
    
    init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping RequestClosure = MoyaProvider.defaultRequestMapping,
         stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
         manager: Manager = RxMoyaProvider<Target>.defaultAlamofireManager(),
         plugins: [PluginType] = []) {
        
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
    }

}

protocol NetworkingType {
    associatedtype T: TargetType
    var provider: LogtimeProvider<T> { get }
}

struct Networking: NetworkingType {
    typealias T = LogtimeAPI
    let provider: LogtimeProvider<LogtimeAPI>
}

struct AuthorizedNetworking: NetworkingType {
    typealias T = LogtimeAPI
    let provider: LogtimeProvider<LogtimeAPI>
}

extension Networking {
    func request(_ token: LogtimeAPI, defaults: UserDefaults = UserDefaults.standard) -> Observable<Moya.Response> {
        return self.provider.request(token)
    }
}

extension AuthorizedNetworking {
    func request(_ token: LogtimeAPI, defaults: UserDefaults = UserDefaults.standard) -> Observable<Moya.Response> {
        return self.provider.request(token)
    }
}

extension NetworkingType {
    
    static func newDefaultNetworking() -> Networking {
        return Networking(provider: newProvider(plugins))
    }
    
    static func newAuthorizedNetworking() -> AuthorizedNetworking {
        return AuthorizedNetworking(provider: newProvider(authenticatedPlugins))
    }
    
    static var plugins: [PluginType] {
        return [
            NetworkLoggerPlugin(verbose: true, cURL: true)
        ]
    }
    
    static var authenticatedPlugins: [PluginType] {
        return [
            NetworkLoggerPlugin(verbose: true, cURL: true),
            LogtimeAccessTokenPlugin()
        ]
    }
}

private func newProvider<T>(_ plugins: [PluginType]) -> LogtimeProvider<T> where T: TargetType {
        return LogtimeProvider<T>(plugins: plugins)
}

