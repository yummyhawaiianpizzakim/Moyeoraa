//
//  AppCoordinator.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/24/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import UIKit

final class AppCoordinator: CoordinatorProtocol {
    // MARK: - Properties
    var finishDelegate: CoordinatorFinishDelegate?
    var type: CoordinatorType = .app
    var navigation: UINavigationController
    var childCoordinators: [CoordinatorProtocol] = []
    
    // MARK: - Initializers
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    // MARK: - Methods
    func start() {
        self.showAuthFeature()
    }
}

// MARK: - connectFlow Methods
extension AppCoordinator {
    func showAuthFeature() {
        self.navigation.viewControllers.removeAll()
        let signInCoordinator = SignInCoordinator(navigation: self.navigation)
        signInCoordinator.finishDelegate = self
        signInCoordinator.start()
        self.childCoordinators.append(signInCoordinator)
    }
    
    func showTabBarFeature() {
        self.navigation.popToRootViewController(animated: true)
        let tabBarCoordinator = MainTabBarCoordinator(navigation: self.navigation)
        tabBarCoordinator.finishDelegate = self
        tabBarCoordinator.start()
        self.childCoordinators.append(tabBarCoordinator)
    }
    
}

// MARK: - Coodinator Delegate
extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        self.childCoordinators = childCoordinators.filter({ coordinator in
            coordinator.type != childCoordinator.type
        })
        self.navigation.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .signIn:
            self.showTabBarFeature()
            return
        case .tab:
            self.showAuthFeature()
            return
        default:
            return
        }
    }
}
