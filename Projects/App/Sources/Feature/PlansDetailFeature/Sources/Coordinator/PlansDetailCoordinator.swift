//
//  PlansDetailCoordinator.swift
//  PlansDetailFeatureInterface
//
//  Created by 김요한 on 2024/04/11.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class PlansDetailCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .plansDetail
    
    public let navigation: UINavigationController
    
    public let plansID: String
    
    public init(navigation: UINavigationController,
         plansID: String) {
        self.navigation = navigation
        self.plansID = plansID
    }
    
    public func start() {
        self.showPlansDetailFeature()
    }
    
    private func showPlansDetailFeature() {
        let firebaseService = FireBaseServiceImpl.shared
        let tokenManager = KeychainTokenManager.shared
        
        let plansRepository = PlansRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        let userRepository = UserRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        let chatRepository = ChatRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        
        let fetchPlansUseCase = FetchPlansUseCaseImpl(plansRepository: plansRepository)
        let fetchUserUseCase = FetchUserUseCaseImpl(userRepository: userRepository)
        let deletePlansUseCase = DeletePlansUseCaseImpl(plansRepository: plansRepository)
        let deleteChatRoomUseCase = DeleteChatRoomUseCaseImpl(chatRepository: chatRepository)
        
//        let fetchPlansUseCase = FetchPlansUseCaseSpy()
//        let fetchUserUseCase = FetchUserUseCaseSpy()
//        let deletePlansUseCase = DeletePlansUseCaseSpy()
        
        let vm = PlansDetailViewModel(
            plansID: self.plansID,
            fetchPlansUseCase: fetchPlansUseCase,
            fetchUserUseCase: fetchUserUseCase,
            deletePlansUseCase: deletePlansUseCase, 
            deleteChatRoomUseCase: deleteChatRoomUseCase)
        
        vm.setAction(
            PlansDetailViewModelActions(
                showChatRoomFeature: showChatRoomFeature,
                showModifyPlansFeature: showModifyPlansFeature,
                finishPlansDetailFeature: finishPlansDetailFeature
            )
        )
        
        let vc = PlansDetailFeature(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    private lazy var showChatRoomFeature: (_ id: String, _ title: String) -> Void = { id, title in
        let coordinator = ChatDetailCoordinator(navigation: self.navigation, chatRoomID: id, chatRoomTitle: title)
        self.childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
    }
    
    private lazy var showModifyPlansFeature: (_ id: String) -> Void = { id in
        let coordinator = ModifyPlansCoordinator(navigation: self.navigation, plansID: id)
        self.childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
    }
    
    private lazy var finishPlansDetailFeature: () -> Void = {
        self.finish()
        self.navigation.popViewController(animated: true)
        let toastView = MYRToastView(type: .success, message: "성공적으로 약속을 삭제했습니다", followsUndockedKeyboard: false)
        toastView.show(in: self.navigation.view)
    }
    
}

extension PlansDetailCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        
    }
    
}
