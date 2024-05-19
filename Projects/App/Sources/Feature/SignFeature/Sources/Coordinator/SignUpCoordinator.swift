//
//  SignUpCoordinator.swift
//  SignFeature
//
//  Created by 김요한 on 2024/04/15.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class SignUpCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .signUp
    
    public let navigation: UINavigationController
    
    private let userID: String
    
    public init(navigation: UINavigationController, userID: String) {
        self.navigation = navigation
        self.userID = userID
    }
    
    public func start() {
        self.showSignUpFeature()
    }
    
    private func showSignUpFeature() {
        let firebaseService = FireBaseServiceImpl.shared
        let tokenManager = KeychainTokenManager.shared
        
        let authRepository = AuthRepositoryImpl(firebaseService: firebaseService, tokenManager: tokenManager)
        let imageRepository = ImageRepositoryImpl(fireBaseService: firebaseService, tokenManager: tokenManager)
        
        let uploadImageUseCase = UploadImageUseCaseImpl(imageRepository: imageRepository)
        let signUpUseCase = SignUpUseCaseImpl(authRepository: authRepository)
        
        let vm = SignUpViewModel(
            uploadImageUseCase: uploadImageUseCase,
            signUpUseCase: signUpUseCase
        )
        
        vm.setAction(
            SignUpViewModelActions(
                finishSignUpFeature: self.finishSignUpFeature))
       
        let vc = SignUpFeature(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    private lazy var finishSignUpFeature: () -> Void = {
        self.finish()
        self.navigation.popViewController(animated: true)
    }
}

extension SignUpCoordinator: CoordinatorFinishDelegate {
    public func coordinatorDidFinished(childCoordinator: CoordinatorProtocol) {
        
    }
    
}
