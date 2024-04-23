//
//  FriendsCoordinator.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class FriendsCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .friends
    
    public let navigation: UINavigationController
    
    private let userID: String
    
    public init(navigation: UINavigationController, userID: String) {
        self.navigation = navigation
        self.userID = userID
    }
    public func start() {
        self.showFriendsFeature()
    }
    
    private func showFriendsFeature() {
        let fetchFriendsUseCase = FetchFriendsUseCaseSpy()
        let searchUserUseCase = SearchUserUseCaseSpy()
        let createFriendUseCase = CreateFriendUseCaseSpy()
        let deleteFriendUseCase = DeleteFriendUseCaseSpy()
        let vm = FriendsViewModel(
            fetchFriendsUseCase: fetchFriendsUseCase,
            searchUserUseCase: searchUserUseCase,
            createFriendUseCase: createFriendUseCase,
            deleteFriendUseCase: deleteFriendUseCase)
        
        let vc = FriendsFeature(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
}
