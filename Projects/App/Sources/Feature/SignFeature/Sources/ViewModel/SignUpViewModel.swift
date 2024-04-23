//
//  SignUpViewModel.swift
//  SignFeature
//
//  Created by 김요한 on 2024/04/15.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseAuth

public struct SignUpViewModelActions {
    var finishSignUpFeature: () -> Void
}

public final class SignUpViewModel: BaseViewModel {
    public typealias Action = SignUpViewModelActions
    public let disposeBag = DisposeBag()
    public var actions: Action?
    
    private let uploadImageUseCase: UploadImageUseCaseProtocol
    private let signUpUseCase: SignUpUseCaseProtocol
    
    init(uploadImageUseCase: UploadImageUseCaseProtocol, signUpUseCase: SignUpUseCaseProtocol) {
        self.uploadImageUseCase = uploadImageUseCase
        self.signUpUseCase = signUpUseCase
    }
    
    public struct Input {
        let name: Observable<String>
        let profileImage: Observable<Data?>
        let doneButtonDidTap: Observable<Void>
    }
    
    public struct Output {
        let doneButtonEnabled: Driver<Bool>
    }
    
    public func trnasform(input: Input) -> Output {
        
        let editedProfile = Observable
            .combineLatest(
                input.name.startWith(""),
                input.profileImage.startWith(nil)
            )
            .share()
        
        input.doneButtonDidTap
            .debug("doneButtonDidTap")
            .withLatestFrom(editedProfile)
            .withUnretained(self)
            .flatMapFirst { owner, val -> Observable<Void> in
                let (name, imageData) = val
                return owner.signUp(imageData: imageData, name: name)
            }
//            .flatMap({ _ in
//                Observable<Void>.error(RxCocoaError.unknown)
//            })
            .subscribe(with: self) { owner, _ in
                owner.actions?.finishSignUpFeature()
            }
            .disposed(by: self.disposeBag)
        
        let buttonEnabled = editedProfile
            .withUnretained(self)
            .map { owner, val in
                let (name, _) = val
                return owner.isButtonEnabled(name: name)
            }
        
        return Output(doneButtonEnabled: buttonEnabled.asDriver(onErrorJustReturn: false))
    }
    
    public func setAction(_ actions: SignUpViewModelActions) {
        self.actions = actions
    }
    
}

private extension SignUpViewModel {
    func signUp(imageData: Data?, name: String) -> Observable<Void> {
        guard let imageData
        else { return self.signUpUseCase.signUp(name: name, profileImage: nil)
        }
        return self.uploadImageUseCase.upload(imageData: imageData)
            .flatMap { url in
                self.signUpUseCase.signUp(name: name, profileImage: url)
            }
    }
    
    func isButtonEnabled(name: String) -> Bool {
        name.isEmpty ? false : true
    }
}
