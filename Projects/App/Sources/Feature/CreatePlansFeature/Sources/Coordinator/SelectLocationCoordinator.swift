//
//  SelectLocationCoordinator.swift
//  CreatePlansFeatureInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public protocol SelectLocationCoordinatorDelegate: AnyObject {
    func submitLocation(_ location: Address)
}

public final class SelectLocationCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .selectLocation
    
    public let navigation: UINavigationController
    
    public weak var delegate: SelectLocationCoordinatorDelegate?
    
    public init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    public func start() {
        self.showSelectLocationFeature()
    }
    
    private func showSelectLocationFeature() {
        let searchLocationUseCase = SearchLocationUseCaseSpy()
        
        let vm = SelectLocationViewModel(searchLocationUseCase: searchLocationUseCase)
        
        vm.setAction(
            SelectLocationViewModelActions(
                closeSelectLocationFeature: closeSelectLocationFeature
            )
        )
        
        let vc = SelectLocationFeature(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    private lazy var closeSelectLocationFeature: (_ address: Address) -> Void = { address in
        self.navigation.popViewController(animated: true)
        self.finish()
        self.delegate?.submitLocation(address)
    }
}

extension SelectLocationCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        
    }
    
}
