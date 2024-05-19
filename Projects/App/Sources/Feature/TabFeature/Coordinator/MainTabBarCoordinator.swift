//
//  MainTabBarCoordinator.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/24/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import UIKit

public final class MainTabBarCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .tab
    
    private let navigation: UINavigationController
    
    private let tabBarController = MainTabBarController()
    
    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    public func start() {
        self.showMainTabBarController()
    }
    
    
    private func showMainTabBarController() {
        let pages: [TabBarPageType] = TabBarPageType.allCases
        let controllers: [UINavigationController] = pages.map {
            self.createTabNavigationController(of: $0)
        }
        self.configureTabBarController(with: controllers)
    }
    
    func currentPage() -> TabBarPageType? {
        return TabBarPageType(rawValue: self.tabBarController.selectedIndex)
    }
    
    func selectPage(_ page: TabBarPageType) {
        self.tabBarController.selectedIndex = page.rawValue
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPageType(rawValue: index) else { return }
        self.tabBarController.selectedIndex = page.rawValue
    }
    
}

private extension MainTabBarCoordinator {
    private func configureTabBarController(with tabViewControllers: [UIViewController]) {
        self.tabBarController.setViewControllers(tabViewControllers, animated: false)
        self.tabBarController.selectedIndex = TabBarPageType.home.rawValue
        self.tabBarController.view.backgroundColor = .moyeora(.neutral(.white))
        self.tabBarController.tabBar.backgroundColor = .moyeora(.neutral(.white))
        self.tabBarController.tabBar.tintColor = .moyeora(.primary(.primary2))
        self.tabBarController.tabBar.unselectedItemTintColor = .moyeora(.neutral(.gray4))
        self.navigation.setNavigationBarHidden(true, animated: false)
        self.navigation.pushViewController(tabBarController, animated: false)
    }
    
    func createTabNavigationController(of page: TabBarPageType) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = page.tabBarItem
        connectTabCoordinator(of: page, to: tabNavigationController)
        return tabNavigationController
    }
    
    func connectTabCoordinator(of page: TabBarPageType, to tabNavigationController: UINavigationController) {
        switch page {
        case .home:
            self.connectHomeFlow(to: tabNavigationController)
        case .chat:
            self.connectChatFlow(to: tabNavigationController)
        case .myPage:
            self.connectMyPageFlow(to: tabNavigationController)
        }
    }
    
    func connectHomeFlow(to tabNavigationController: UINavigationController) {
        let homeCoordinator = HomeCoordinator(navigation: tabNavigationController)
        homeCoordinator.finishDelegate = self
        homeCoordinator.start()
        childCoordinators.append(homeCoordinator)
    }
    
    func connectChatFlow(to tabNavigationController: UINavigationController) {
        let chatListCoordinator = ChatListCoordinator(navigation: tabNavigationController)
        chatListCoordinator.finishDelegate = self
        chatListCoordinator.start()
        childCoordinators.append(chatListCoordinator)
    }
    
    func connectMyPageFlow(to tabNavigationController: UINavigationController) {
        let myPageCoordinator = MyPageCoordinator(navigation: tabNavigationController)
        myPageCoordinator.finishDelegate = self
        myPageCoordinator.start()
        childCoordinators.append(myPageCoordinator)
    }
}

extension MainTabBarCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        self.navigation.popToRootViewController(animated: false)
        self.finish()
    }
}
