//
//  BlockUserCoordinator.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class BlockUserCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .blockUser
    
    public let navigation: UINavigationController
    
    private let userID: String
    
    public init(navigation: UINavigationController, userID: String) {
        self.navigation = navigation
        self.userID = userID
    }
    
    public func start() {
        self.showBlockUserFeature()
    }
    
    private func showBlockUserFeature() {
        let fetchBlockedUserUseCase = FetchBlockedUserUseCaseSpy()
        let deleteBlockUseCase = DeleteBlockUseCaseSpy()
        let createBlockUseCase = CreateBlockUseCaseSpy()
        let vm = BlockUserViewModel(
            fetchBlockedUserUseCase: fetchBlockedUserUseCase,
            deleteBlockUseCase: deleteBlockUseCase,
            createBlockUseCase: createBlockUseCase
        )
        
        let vc = BlockUserFeature(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
}
