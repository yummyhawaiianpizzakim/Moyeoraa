//
//  EditProfileViewModel.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

public struct EditProfileViewModelActions {
    var finishEditProfileFeature: () -> Void
}

public final class EditProfileViewModel: BaseViewModel {
    public var disposeBag = DisposeBag()
    public typealias Action = EditProfileViewModelActions
    public var actions: Action?
    public var defaultName: String?
//    private let profileImage = PublishSubject<Data?>()
    
    private let fetchUserUseCase: FetchUserUseCaseProtocol
    private let updateUserUseCase: UpdateUserUseCaseProtocol
    private let uploadImageUseCase: UploadImageUseCaseProtocol
    
    public init(fetchUserUseCase: FetchUserUseCaseProtocol,
                updateUserUseCase: UpdateUserUseCaseProtocol,
                uploadImageUseCase: UploadImageUseCaseProtocol) {
        self.fetchUserUseCase = fetchUserUseCase
        self.updateUserUseCase = updateUserUseCase
        self.uploadImageUseCase = uploadImageUseCase
    }
    
    public struct Input {
        let name: Observable<String>
        let profileImage: Observable<Data?>
        let doneButtonDidTap: Observable<Void>
    }
    
    public struct Output {
        let defaultUser: Driver<User>
        let doneButtonEnabled: Driver<Bool>
        let result: Observable<Void>
    }
    
    public func trnasform(input: Input) -> Output {
        let user = self.fetchUserUseCase.fetch().share()
        
        user.map { $0.name }
            .bind(with: self, onNext: { owner, name in
                owner.defaultName = name
            })
            .disposed(by: self.disposeBag)
        
        let editedProfile = Observable.combineLatest(input.name, input.profileImage).share()
        
        let result = input.doneButtonDidTap
            .withLatestFrom(editedProfile)
            .withUnretained(self)
            .flatMapFirst { owner, val -> Observable<Void> in
                let (name, imageData) = val
                return owner.updateUser(imageData: imageData, name: name)
            }
//            .flatMap({ _ in
//                Observable<Void>.error(RxCocoaError.unknown)
//            })
            .share()
        
        let buttonEnabled = editedProfile
            .withUnretained(self)
            .map { owner, val in
                let (name, imageData) = val
                return owner.isButtonEnabled(name: name, data: imageData)
            }
        
        return Output(
            defaultUser: user.asDriver(onErrorDriveWith: Driver.empty()),
            doneButtonEnabled: buttonEnabled.asDriver(onErrorJustReturn: false),
            result: result
        )
    }
    
    public func setAction(_ actions: EditProfileViewModelActions) {
        self.actions = actions
    }
}

private extension EditProfileViewModel {
    func updateUser(imageData: Data?, name: String) -> Observable<Void> {
        guard let imageData
        else { return self.updateUserUseCase
            .update(profileURL: nil, name: name)
        }
        return self.uploadImageUseCase.upload(imageData: imageData)
            .flatMap { url in
                self.updateUserUseCase.update(profileURL: url, name: name)
            }
    }
    
    func isButtonEnabled(name: String, data: Data?) -> Bool {
        if (name.isEmpty || name == self.defaultName) &&
            data == nil {
            return false
        }
        return true
    }
}
