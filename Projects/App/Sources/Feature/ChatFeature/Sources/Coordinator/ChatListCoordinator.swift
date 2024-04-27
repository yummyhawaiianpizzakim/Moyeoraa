//
//  ChatListCoordinator.swift
//  ChatFeatureInterface
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class ChatListCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .chat
    
    public let navigation: UINavigationController
    
    public init(navigation : UINavigationController) {
        self.navigation = navigation
    }
    
    public func start() {
        self.showChatListFeature()
    }
    
    private func showChatListFeature() {
//        let uc = ObserveChatListUseCaseSpy()
        
        let firebaseService = FireBaseServiceImpl.shared
        let tokenManager = KeychainTokenManager.shared
        
        let plansRepository = PlansRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        let chatRepository =  ChatRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        
        let fetchChatUseCase = ObserveChatListUseCaseImpl(chatRepository: chatRepository, plansRepository: plansRepository)
        
        let vm = ChatListViewModel(fetchChatUseCase: fetchChatUseCase)
        
        let vc = ChatListFeature(viewModel: vm)
        vm.setAction(
            ChatListViewModelActions(
                showChatDetailFeature: self.showChatDetailFeature
            )
        )
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    lazy var showChatDetailFeature: (_ id: String, _ title: String) -> Void = { id, title in
        let navigation = self.navigation
        let chatDetailCoordinator = ChatDetailCoordinator(
            navigation: navigation,
            chatRoomID: id,
            chatRoomTitle: title
        )
        chatDetailCoordinator.finishDelegate = self
        self.childCoordinators.append(chatDetailCoordinator)
        chatDetailCoordinator.start()
    }
}

extension ChatListCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
    }
}
