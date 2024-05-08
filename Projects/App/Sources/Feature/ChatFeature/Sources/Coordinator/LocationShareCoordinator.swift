//
//  LocationShareCoordinator.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/3/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import UIKit

public final class LocationShareCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .shareLocation
    
    public let navigation: UINavigationController
    
    private let chatRoomID: String
    
    public init(chatRoomID: String, navigation : UINavigationController) {
        self.chatRoomID = chatRoomID
        self.navigation = navigation
    }
    
    public func start() {
        self.showLocationShareFeature()
    }
    
    private func showLocationShareFeature() {
        let firebaseService = FireBaseServiceImpl.shared
        let tokenManager = KeychainTokenManager.shared
        
        let plansRepository = PlansRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        let userRepository = UserRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        let locationRepository = LocationRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        
        let fetchUserUseCase = FetchUserUseCaseImpl(userRepository: userRepository)
        let updateLocationUseCase = UpdateLocationUseCaseImpl(locationRepository: locationRepository)
        let fetchPlansUseCase = FetchPlansUseCaseImpl(plansRepository: plansRepository)
        let observeLocationUseCase = ObserveLocationUseCaseImpl(locationRepository: locationRepository)
        let endLocationShareUseCase = EndLocationShareUseCaseImpl(locationRepository: locationRepository)
        
        let vm = LocationShareViewModel(
            chatRoomID: self.chatRoomID,
            fetchPlansUseCase: fetchPlansUseCase,
            fetchUserUseCase: fetchUserUseCase,
            updateLocationUseCase: updateLocationUseCase,
            observeLocationUseCase: observeLocationUseCase,
            endLocationShareUseCase: endLocationShareUseCase
        )
        
        let vc = LocationShareFeature(viewModel: vm)
        vc.hidesBottomBarWhenPushed = true
        
        self.navigation.pushViewController(vc, animated: true)
    }
}

extension LocationShareCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        childCoordinators = childCoordinators.filter {
            $0.type != childCoordinator.type
        }
    }
}
