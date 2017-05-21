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
        let loginCoordinator = LoginCoordinator(navigationController: navigationController, appCoordinator: self)
        childCoordinators.append(loginCoordinator)
        
        loginCoordinator.start()
    }
    
    func loginCoordinatorCompleted(coordinator: LoginCoordinator) {
        if let index = childCoordinators.index(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
        
        let timesheetsCoordinator = TimesheetsCoordinator(navigationController: navigationController, appCoordinator: self)
        childCoordinators.append(timesheetsCoordinator)
        timesheetsCoordinator.start()
    }
}


class LoginCoordinator: Coordinator {
    
    var appCoordinator: AppCoordinator?
    var viewModel: LoginViewModel?
    
    convenience init(navigationController: UINavigationController?, appCoordinator: AppCoordinator) {
        self.init(navigationController: navigationController)
        
        self.appCoordinator = appCoordinator
    }
    
    func start() {
        let provider = Networking.newDefaultNetworking()
        viewModel = LoginViewModel(provider: provider)
        viewModel?.userSignedIn = { [weak self] user in
            self?.stop()
        }
        guard let viewModel = viewModel else { return }
        let loginViewController = LoginViewController(viewModel: viewModel)
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func stop() {
        _ = navigationController?.popViewController(animated: false)
        appCoordinator?.loginCoordinatorCompleted(coordinator: self)
    }
}

class TimesheetsCoordinator: Coordinator {
    
    var appCoordinator: AppCoordinator?
    
    convenience init(navigationController: UINavigationController?, appCoordinator: AppCoordinator) {
        self.init(navigationController: navigationController)
        
        self.appCoordinator = appCoordinator
    }
    
    func start() {
        let provider = AuthorizedNetworking.newAuthorizedNetworking()
        let viewModel = TimesheetsViewModel(authorizedProvider: provider)
        let timesheetsTableViewController = TimesheetsTableViewController(viewModel: viewModel)
        navigationController?.viewControllers = [timesheetsTableViewController]
    }
    
}
