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
    
    var rxProvider: RxMoyaProvider<LogtimeAPI>!
    
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
        rxProvider = RxMoyaProvider<LogtimeAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
        
        rxProvider.request(LogtimeAPI.authenticate(username: "x@x.com", password: "password"))
            .debug()
            .mapObject(AuthResponse.self)
            .subscribe{ event in
                switch event {
                case .next(let authResponse):
                    print("Name: \(authResponse.user.name) + \(authResponse.user.email)")
                    break
                case .error(let error):
                    print("error: \(error)")
                    break
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }
}

