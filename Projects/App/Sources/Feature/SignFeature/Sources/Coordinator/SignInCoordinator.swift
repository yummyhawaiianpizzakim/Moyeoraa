//
//  SignInCoordinator.swift
//  SignFeatureInterface
//
//  Created by 김요한 on 2024/04/15.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class SignInCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .signIn
    
    public let navigation: UINavigationController
    
    private var viewController: SignInFeature?
    
    public init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    public func start() {
        self.showSignInFeature()
    }
    
    private func showSignInFeature() {
        let firebaseService = FireBaseServiceImpl.shared
        let tokenManager = KeychainTokenManager.shared
        
        let authRepository = AuthRepositoryImpl(
            firebaseService: firebaseService,
            tokenManager: tokenManager
        )
        
        let signInUseCase = SignInUseCaseImpl(authRepository: authRepository)
        let vm = SignInViewModel(
            signInUseCase: signInUseCase
        )
        
        vm.setAction(
            SignInViewModelActions(
                showSignUpFeature: showSignUpFeature,
                finishSignInFeature: finishSignInFeature
            )
        )
        
        let vc = SignInFeature(viewModel: vm)
        
        self.viewController = vc
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    private lazy var showSignUpFeature: (_ id: String) -> Void = { id in
        let coordinator = SignUpCoordinator(navigation: self.navigation, userID: id)
        self.childCoordinators.append(coordinator)
        coordinator.finishDelegate = self
        coordinator.start()
    }
    
    private lazy var finishSignInFeature: () -> Void = {
        self.finish()
        self.navigation.popViewController(animated: true)
    }
}

extension SignInCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        if childCoordinator.type == .signUp {
            self.viewController?.viewModel.signUpSuccess.accept(())
        }
    }
    
}
