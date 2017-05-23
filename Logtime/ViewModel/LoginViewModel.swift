//
//  LoginViewModel.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 21/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import RxSwift
import RxSwiftUtilities
import Moya_ObjectMapper
import ObjectMapper

enum NetworkError: Error {
    case server
    case badResponse
}

enum AuthenticationError: Error {
    case server
    case badReponse
    case badCredentials
    
    var title: String {
        switch self {
        case .server, .badReponse:
            return "An error occured"
        case .badCredentials:
            return "Bad credentials"
        }
    }
    var message: String {
        switch self {
        case .server, .badReponse:
            return "Server error. Please try after some time."
        case .badCredentials:
            return "Please enter correct credentials to sign-in."
        }
    }
}

enum AuthStatus {
    case success(User)
    case faliure(AuthenticationError)
}

enum UsernameValidationError: Error {
    case badEmail
    case empty
    case none
    
    var title: String {
        switch self {
        case .badEmail, .empty:
            return "Username error"
        case .none:
            return ""
        }
    }
    
    var message: String {
        switch self {
        case .badEmail:
            return "Please enter correct email address"
        case .empty:
            return ""
        case .none:
            return ""
        }
    }
}

enum PasswordValidationError: Error {
    case length
    case empty
    case none
    
    var title: String {
        switch self {
        case .length, .empty:
            return "Password error"
        case .none:
            return ""
        }
    }
    
    var message: String {
        switch self {
        case .length:
            return "Password should be more than 8 characters"
        case .empty:
            return ""
        case .none:
            return ""
        }
    }
}

struct LoginViewModel {
    
    let provider: Networking!
    let disposeBag = DisposeBag()
    let activityIndicator = ActivityIndicator()
    
    var username = Variable<String>("")
    var password = Variable<String>("")
    var userSignedIn: ((User) -> Void)?
    
    var isUsernameValid: Observable<UsernameValidationError> {
        return username.asObservable()
            .map { username in
                if username.isEmpty {
                    return .empty
                } else if !username.isEmail() {
                    return .badEmail
                } else {
                    return .none
                }
            }
            .startWith(.none)
    }
    
    var isPasswordValid: Observable<PasswordValidationError> {
        return password.asObservable()
            .map { password in
                if password.isEmpty {
                    return .empty
                } else if password.characters.count < 8 {
                    return .length
                } else {
                    return .none
                }
            }
            .startWith(.none)
    }
    
    
    var isValid: Observable<Bool> {
        return Observable<Bool>.combineLatest(self.isUsernameValid, self.isPasswordValid) { username, password in
            if username == .none && password == .none {
                return true
            }
            return false
        }.startWith(false) 
    }
    
    init(provider: Networking) {
        self.provider = provider
    }
    
    func authenticate(username: String, password: String) -> Observable<AuthStatus> {
        return provider.request(.authenticate(username: username, password: password))
            .debug()
            .mapObject(AuthResponse.self)
            .map { authResponse in
                guard let user = authResponse.user else { return AuthStatus.faliure(.badReponse) }
                print("Name: \(user.name) + \(user.email)")

                var token = XAppToken()
                token.token = user.authToken
                token.mail = user.email
                self.userSignedIn?(user)

                return AuthStatus.success(user)
            }
            .catchErrorJustReturn(.faliure(.badCredentials))
    }
}
