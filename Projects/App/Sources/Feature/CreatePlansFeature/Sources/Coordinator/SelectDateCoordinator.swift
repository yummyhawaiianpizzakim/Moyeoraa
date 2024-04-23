//
//  SelectDateCoordinator.swift
//  CreatePlansFeatureInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public protocol SelectDateCoordinatorDelegate: AnyObject {
    func submitDate(_ date: Date)
}

public final class SelectDateCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .selectDate
    
    public let navigation: UINavigationController
    
    public weak var delegate: SelectDateCoordinatorDelegate?
    
    public init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    public func start() {
        self.showSelectDateFeature()
    }
    
    private func showSelectDateFeature() {
        let vm = SelectDateViewModel()
        vm.setAction(SelectDateViewModelActions(closeSelectDateFeature: closeSelectDateFeature))
        
        let vc = SelectDateFeature(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    lazy var closeSelectDateFeature: (_ date: Date) -> Void = { date in
        self.delegate?.submitDate(date)
        print("closeSelectDateFeature")
        self.navigation.popViewController(animated: true)
        self.finish()
    }
}

extension SelectDateCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        
    }
    
}
