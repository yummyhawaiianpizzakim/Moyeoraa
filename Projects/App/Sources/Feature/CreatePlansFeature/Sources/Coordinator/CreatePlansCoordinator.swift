//
//  CreatePlansCoordinator.swift
//  CreatePlansFeatureInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class CreatePlansCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .createPlans
    
    public let navigation: UINavigationController
    
    public init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    public func start() {
        self.showCreatePlansViewModel()
    }
    
    private func showCreatePlansViewModel() {
        let createPlansUseCase = CreatePlansUseCaseSpy()
        let vm = CreatePlansViewModel(createPlansUseCase: createPlansUseCase)
        
        vm.setAction(
            CreatePlansViewModelActions(
                showSelectDateFeature: showSelectDateFeature,
                showSelectLocationFeature: showSelectLocationFeature,
                showSelectMemberFeature: showSelectMemberFeature,
                finishCreatePlansFeature: finishCreatePlansFeature
            )
        )
        
        let vc = CreatePlansFeature(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    private lazy var showSelectDateFeature: (_ viewModel: CreatePlansViewModel) -> Void = { viewModel in
        let coordinator = SelectDateCoordinator(navigation: self.navigation)
        self.childCoordinators.append(coordinator)
        coordinator.delegate = viewModel
        coordinator.start()
        coordinator.finishDelegate = self
    }
    
    private lazy var showSelectLocationFeature: (_ viewModel: CreatePlansViewModel) -> Void = { viewModel in
        let coordinator = SelectLocationCoordinator(navigation: self.navigation)
        self.childCoordinators.append(coordinator)
        coordinator.delegate = viewModel
        coordinator.start()
        coordinator.finishDelegate = self
    }
    
    private lazy var showSelectMemberFeature: (_ members: [User], _ viewModel: CreatePlansViewModel) -> Void = { members, viewModel in
        let coordinator = SelectMemberCoordinator(navigation: self.navigation, members: members)
        self.childCoordinators.append(coordinator)
        coordinator.delegate = viewModel
        coordinator.start()
        coordinator.finishDelegate = self
    }
    
    private lazy var finishCreatePlansFeature: () -> Void = {
        self.finish()
        self.navigation.popViewController(animated: true)
        let toastView = MYRToastView(type: .success, message: "성공적으로 약속을 생성했습니다", followsUndockedKeyboard: false)
        toastView.show(in: self.navigation.view)
    }
}

extension CreatePlansCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        
    }
    
}
