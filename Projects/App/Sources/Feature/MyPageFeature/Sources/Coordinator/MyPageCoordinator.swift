//
//  MyPageCoordinator.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import UIKit

public final class MyPageCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .myPage
    
    public let navigation: UINavigationController
    
    public init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    public func start() {
        self.showMyPageFeature()
    }
    
    private func showMyPageFeature() {
        let fetchUserUseCase = FetchUserUseCaseSpy()
        let updateNotificationUseCase = UpdateNotificationUseCaseSpy()
        let signOutUseCase = SignOutUseCaseSpy()
        let dropOutUseCase = DropOutUseCaseSpy()
        
        let vm = MyPageViewModel(
            fetchUserUseCase: fetchUserUseCase,
            updateNotificationUseCase: updateNotificationUseCase,
            signOutUseCase: signOutUseCase,
            dropOutUseCase: dropOutUseCase)
        
        vm.setAction(MyPageViewModelActions(
            showEditProfileFeature: showEditProfileFeature,
            showFriendsFeature: showFriendsFeature,
            showBlockUserFeature: showBlockUserFeature)
        )
        let vc = MyPageFeature(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    lazy var showEditProfileFeature: (_ id: String) -> Void = { id in
        let coordinator = EditProfileCoordinator(navigation: self.navigation, userID: id)
        
        coordinator.finishDelegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    lazy var showFriendsFeature: (_ id: String) -> Void = { id in
        let coordinator = FriendsCoordinator(navigation: self.navigation, userID: id)
        
        coordinator.finishDelegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    lazy var showBlockUserFeature: (_ id: String) -> Void = { id in
        let coordinator = BlockUserCoordinator(navigation: self.navigation, userID: id)
        
        coordinator.finishDelegate = self
        self.childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension MyPageCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        
    }
    
}
