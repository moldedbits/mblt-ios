//
//  ViewController.swift
//  Logtime
//
//  Created by Amit kumar Swami on 18/04/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import UIKit
import Moya
import RxMoya
import RxSwift
import Moya_ObjectMapper

class ViewController: UIViewController {
    
    var provider: Networking!
    
    let disposeBag: DisposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        setupRx()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRx() {
        provider = Networking.newDefaultNetworking()
        
        provider.request(.authenticate(username: "x@x.com", password: "password"))
            .debug()
            .mapObject(AuthResponse.self)
            .subscribe{ event in
                switch event {
                case .next(let authResponse):
                    guard let user = authResponse.user else { return }
                    print("Name: \(user.name) + \(user.email)")
                    var token = XAppToken()
                    token.token = user.authToken
                    token.mail = user.email
                    self.getTimesheets(user: user)
                    break
                case .error(let error):
                    print("error: \(error)")
                    break
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }
    
    func getTimesheets(user: User) {
        
        let authorizedProvider = AuthorizedNetworking.newAuthorizedNetworking()
        authorizedProvider.request(.timesheets)
            .mapArray(Timesheet.self)
            .subscribe { event in
                switch event {
                case .next(let response):
                    print(response)
                    break
                case .error(let error):
                    print("error: \(error)")
                    break
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
        
        authorizedProvider.request(.projects)
            .mapArray(Project.self)
            .subscribe { event in
                switch event {
                case .next(let response):
                    print(response)
                    break
                case .error(let error):
                    print("error: \(error)")
                    break
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
        
        authorizedProvider.request(.clients)
            .mapArray(Client.self)
            .subscribe { event in
                switch event {
                case .next(let response):
                    print(response)
                    break
                case .error(let error):
                    print("error: \(error)")
                    break
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
        
        let timesheet = Timesheet(
    }
    
}


