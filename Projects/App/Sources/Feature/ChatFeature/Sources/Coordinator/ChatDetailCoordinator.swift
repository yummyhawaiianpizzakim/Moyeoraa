//
//  ChatDetailCoordinator.swift
//  ChatFeature
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class ChatDetailCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .chatDetail
    
    public let navigation: UINavigationController
    
    private let plansID: String
    private let chatRoomID: String
    private let chatRoomTitle: String
    
    public init(navigation: UINavigationController,
                plansID: String,
                chatRoomID: String,
                chatRoomTitle: String) {
        self.plansID = plansID
        self.navigation = navigation
        self.chatRoomID = chatRoomID
        self.chatRoomTitle = chatRoomTitle
    }
    
    public func start() {
        self.showChatDetailFeature()
    }
    
    private func showChatDetailFeature() {
        let firebaseService = FireBaseServiceImpl.shared
        let tokenManager = KeychainTokenManager.shared
        
        let chatRepository = ChatRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        let userRepository = UserRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        let plansRepository = PlansRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        
        let observeChatUseCase = ObserveChatUseCaseImpl(chatRepository: chatRepository, userRepository: userRepository)
        let sendChatUseCase = SendChatUseCaseImpl(chatRepository: chatRepository)
        let updateIsCheckedUseCase = UpdateIsCheckedUseCaseImpl(chatRepository: chatRepository)
        let checkLocationShareEnableUseCase = CheckLocationShareEnableUseCaseImpl(plansRepository: plansRepository)
        let exitChatRoomUseCase = ExitChatRoomUseCaseImpl(plansRepository: plansRepository)
        
        let vm = ChatDetailViewModel(
            plansID: self.plansID,
            chatRoomID: self.chatRoomID,
            chatRoomTitle: self.chatRoomTitle,
            observeChatUseCase: observeChatUseCase,
            sendChatUseCase: sendChatUseCase,
            updateIsCheckedUseCase: updateIsCheckedUseCase, 
            checkLocationShareEnableUseCase: checkLocationShareEnableUseCase,
            exitChatRoomUseCase: exitChatRoomUseCase
        )
        
        vm.setAction(
            ChatDetailViewModelActions(
                showLocationShareFeature: showLocationShareFeature,
                showPlansDetailFeature: showPlansDetailFeature,
                exitChatDetailFeature: exitChatDetailFeature)
        )
        
        let vc = ChatDetailFeature(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    private lazy var showLocationShareFeature: (_ id: String) -> Void = { id in
        let coordinator = LocationShareCoordinator(chatRoomID: id, navigation: self.navigation)
        self.childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
    }
    
    private lazy var showPlansDetailFeature: (_ id: String) -> Void = { id in
        if self.navigation.viewControllers
            .contains(where: { $0 is PlansDetailFeature }) {
            self.navigation.popViewController(animated: true)
        } else { 
            let coordinator = PlansDetailCoordinator(navigation: self.navigation, plansID: id)
            self.childCoordinators.append(coordinator)
            coordinator.finishDelegate = self
            coordinator.start()
        }
    }
    
    private lazy var exitChatDetailFeature: () -> Void = {
        self.finish()
        self.navigation.popViewController(animated: true)
    }
}

extension ChatDetailCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        
    }
}
