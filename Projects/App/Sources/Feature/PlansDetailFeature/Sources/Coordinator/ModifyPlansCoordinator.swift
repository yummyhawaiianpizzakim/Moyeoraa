//
//  ModifyPlansCoordinator.swift
//  PlansDetailFeature
//
//  Created by 김요한 on 2024/04/11.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class ModifyPlansCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .modifyPlans
    
    public let navigation: UINavigationController
    
    private let plansID: String
    
    public init(navigation: UINavigationController,
         plansID: String) {
        self.navigation = navigation
        self.plansID = plansID
    }
    
    public func start() {
        self.showModifyPlansFeature()
    }
    
    private func showModifyPlansFeature() {
        let firebaseService = FireBaseServiceImpl.shared
        let tokenManager = KeychainTokenManager.shared
        
        let plansRepository = PlansRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        let userRepository = UserRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        let chatRepository = ChatRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        
        let createPlansUseCase = CreatePlansUseCaseImpl(plansRepository: plansRepository, userRepository: userRepository, chatRepository: chatRepository)
        let updatePlansUseCase = UpdatePlansUseCaseImpl(plansRepository: plansRepository)
        let fetchPlansUseCase = FetchPlansUseCaseImpl(plansRepository: plansRepository)
        let fetchUserUseCase = FetchUserUseCaseImpl(userRepository: userRepository)
        let kickOutUserUseCase = KickOutUserUseCaseImpl(plansRepository: plansRepository)
        
//        let createPlansUseCase = CreatePlansUseCaseSpy()
//        let updatePlansUseCase = UpdatePlansUseCaseSpy()
//        let fetchPlansUseCase = FetchPlansUseCaseSpy()
//        let fetchUserUseCase = FetchUserUseCaseSpy()
        
        let vm = ModifyPlansViewModel(
            plansID: self.plansID,
            updatePlansUseCase: updatePlansUseCase,
            fetchPlansUseCase: fetchPlansUseCase,
            fetchUserUseCase: fetchUserUseCase,
            kickOutUserUseCase: kickOutUserUseCase
        )
        
        vm.setAction(
            ModifyPlansViewModelActions(
                showSelectDateFeature: showSelectDateFeature,
                showSelectLocationFeature: showSelectLocationFeature,
                showSelectMemberFeature: showSelectMemberFeature,
                finishModifyPlansFeature: finishModifyPlansFeature
            )
        )
        
        let vc = ModifyPlansFeature(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    private lazy var showSelectDateFeature: (_ viewModel: ModifyPlansViewModel) -> Void = { viewModel in
        let coordinator = SelectDateCoordinator(navigation: self.navigation)
        self.childCoordinators.append(coordinator)
        coordinator.delegate = viewModel
        coordinator.start()
        coordinator.finishDelegate = self
    }
    
    private lazy var showSelectLocationFeature: (_ viewModel: ModifyPlansViewModel) -> Void = { viewModel in
        let coordinator = SelectLocationCoordinator(navigation: self.navigation)
        self.childCoordinators.append(coordinator)
        coordinator.delegate = viewModel 
        coordinator.start()
        coordinator.finishDelegate = self
    }
    
    private lazy var showSelectMemberFeature: (_ members: [User], _ viewModel: ModifyPlansViewModel) -> Void = { members, viewModel in
        let coordinator = SelectMemberCoordinator(navigation: self.navigation, members: members)
        self.childCoordinators.append(coordinator)
        coordinator.delegate = viewModel
        coordinator.start()
        coordinator.finishDelegate = self
    }
    
    private lazy var finishModifyPlansFeature: () -> Void = {
        self.finish()
        self.navigation.popViewController(animated: true)
        let toastView = MYRToastView(type: .success, message: "성공적으로 약속을 수정했습니다.", followsUndockedKeyboard: false)
        toastView.show(in: self.navigation.view)
    }
}

extension ModifyPlansCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
    }
}
