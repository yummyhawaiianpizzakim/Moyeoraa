//
//  EditProfileCoordinator.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class EditProfileCoordinator: CoordinatorProtocol {
    public var finishDelegate: CoordinatorFinishDelegate?
    
    public var childCoordinators: [CoordinatorProtocol] = []
    
    public var type: CoordinatorType = .editProfile
    
    public let navigation: UINavigationController
    
    private let userID: String
    
    public init(navigation: UINavigationController, userID: String) {
        self.navigation = navigation
        self.userID = userID
    }
    
    public func start() {
        self.showEditProfileFeature()
    }
    
    private func showEditProfileFeature() {
        let fetchUserUseCase = FetchUserUseCaseSpy()
        let updateUserUseCase = UpdateUserUseCaseSpy()
        let uploadImageUseCase = UploadImageUseCaseSpy()
        let vm = EditProfileViewModel(
            fetchUserUseCase: fetchUserUseCase,
            updateUserUseCase: updateUserUseCase,
            uploadImageUseCase: uploadImageUseCase
        )
        
        vm.setAction(EditProfileViewModelActions(finishEditProfileFeature: finishEditProfileFeature))
        
        let vc = EditProfileFeature(viewModel: vm)
        
        self.navigation.pushViewController(vc, animated: true)
    }
    
    lazy var finishEditProfileFeature: () -> Void = {
        self.childCoordinators.removeAll()
        self.finish()
        self.navigation.popViewController(animated: true)
        let toastView = MYRToastView(type: .success, message: "성공적으로 프로필 변경했습니다", followsUndockedKeyboard: false)
        toastView.show(in: self.navigation.view)
    }
}
