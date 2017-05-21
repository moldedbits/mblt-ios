//
//  Coordinator.swift
//  Logtime
//
//  Created by Amit Kumar Swami on 19/05/17.
//  Copyright © 2017 molededbits. All rights reserved.
//

import UIKit

class Coordinator {
    
    var childCoordinators: [Coordinator] = []
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}
