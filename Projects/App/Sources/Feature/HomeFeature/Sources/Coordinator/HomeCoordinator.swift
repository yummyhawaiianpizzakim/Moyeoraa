//
//  HomeCoordinator.swift
//  HomeFeatureInterface
//
//  Created by 김요한 on 2024/04/10.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import UIKit

public final class HomeCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .home
    
    public let navigation: UINavigationController
    
    public init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    public func start() {
        self.showHomeFeature()
    }
    
    private func showHomeFeature() {
        let fetchPlansUseCase = FetchPlansUseCaseSpy()
        
        let vm = HomeViewModel(
            fetchPlansUseCase: fetchPlansUseCase
        )
        
        vm.setAction(
            HomeViewModelActions(
                showCreatePlansFeature: showCreatePlansFeature,
                showPlansDetailFeature: showPlansDetailFeature
            )
        )
        
        let vc = HomeFeature(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    private lazy var showCreatePlansFeature: () -> Void = {
        let coordinator = CreatePlansCoordinator(navigation: self.navigation)
        self.childCoordinators.append(coordinator)
        coordinator.start()
        coordinator.finishDelegate = self
    }
    
    private lazy var showPlansDetailFeature: (_ id: String) -> Void = { id in
        let coordinator = PlansDetailCoordinator(navigation: self.navigation, plansID: id)
        self.childCoordinators.append(coordinator)
        coordinator.start()
        coordinator.finishDelegate = self
    }
}

extension HomeCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        
    }
    
}
