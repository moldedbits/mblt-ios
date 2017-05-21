//
//  AppCoordinator.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 20/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    
    func start() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(loginCoordinator)
        
        loginCoordinator.start()
    }
    
    func loginCoordinatorCompleted(coordinator: LoginCoordinator) {
        if let index = childCoordinators.index(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}


class LoginCoordinator: Coordinator {
    
    var appCoordinator: AppCoordinator?
    
    convenience init(navigationController: UINavigationController?, appCoordinator: AppCoordinator) {
        self.init(navigationController: navigationController)
        
        self.appCoordinator = appCoordinator
    }
    
    func start() {
        let provider = Networking.newDefaultNetworking()
        var viewModel = LoginViewModel(provider: provider)
        viewModel.userSignedIn = { [unowned self] user in
            self.end()
        }
        let loginViewController = LoginViewController(viewModel: viewModel)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func end() {
        _ = navigationController?.popViewController(animated: false)
        appCoordinator?.loginCoordinatorCompleted(coordinator: self)
    }
}

class TimesheetsCoordinator: Coordinator {
    
}
