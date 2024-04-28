//
//  SelectMemberCoordinator.swift
//  CreatePlansFeatureInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public protocol SelectMemberCoordinatorDelegate: AnyObject {
    func submitMembers(_ member: [User])
}


public final class SelectMemberCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .selectMember
    
    public let navigation: UINavigationController
    
    public weak var delegate: SelectMemberCoordinatorDelegate?
    
    private let members: [User]

    public init(navigation: UINavigationController, members: [User]) {
        self.navigation = navigation
        self.members = members
    }
    
    public func start() {
        self.showSelectMemberFeature()
    }
    
    private func showSelectMemberFeature() {
        let firebaseService = FireBaseServiceImpl.shared
        let tokenManager = KeychainTokenManager.shared
        
        let userRepository = UserRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        
        let fetchFriendsUseCase = FetchFriendsUseCaseSpy()
//        let searchUserUseCase = SearchUserUseCaseSpy()
        let searchUserUseCase = SearchUserUseCaseImpl(userRepository: userRepository)
        let createFriendUseCase = CreateFriendUseCaseSpy()
        let deleteFriendUseCase = DeleteFriendUseCaseSpy()
        
        let vm = SelectMemberViewModel(
            fetchFriendsUseCase: fetchFriendsUseCase,
            searchUserUseCase: searchUserUseCase,
            createFriendUseCase: createFriendUseCase,
            deleteFriendUseCase: deleteFriendUseCase
        )
        vm.tagedUsers.accept(self.members)
        
        vm.setAction(
            SelectMemberViewModelActions(
                closeSelectMemberFeature: closeSelectMemberFeature))
        
        let vc = SelectMemberFeature(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    lazy var closeSelectMemberFeature: (_ members: [User]) -> Void = { members in
        self.navigation.popViewController(animated: true)
        self.finish()
        self.delegate?.submitMembers(members)
    }
}

extension SelectMemberCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        
    }
    
}
