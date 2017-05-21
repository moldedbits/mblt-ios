//
//  LoginViewModel.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 21/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import RxSwift
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
}

enum AuthStatus {
    case success(User)
    case faliure(AuthenticationError)
}

struct LoginViewModel {
    
    let provider: Networking!
    let disposeBag = DisposeBag()
    
    var username = Variable<String>("")
    var password = Variable<String>("")
    var userSignedIn: ((User) -> Void)?
    
    
    var isValid: Observable<Bool> {
        return Observable<Bool>.combineLatest(self.username.asObservable(), self.password.asObservable()) { username, password in
            return !username.isEmpty && !password.isEmpty
        }
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
            .catchErrorJustReturn(AuthStatus.faliure(.server))
    }
}
