//
//  SignInViewModel.swift
//  SignFeatureInterface
//
//  Created by 김요한 on 2024/04/15.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift
import RxCocoa
import FirebaseAuth

public struct SignInViewModelActions {
    var showSignUpFeature: (_ id: String) -> Void
    var finishSignInFeature: () -> Void
}

public final class SignInViewModel: BaseViewModel {
    public typealias Action = SignInViewModelActions
    public let disposeBag = DisposeBag()
    public var actions: Action?
    private let signInFailure = PublishRelay<Void>()
    public let signUpSuccess = PublishRelay<Void>()
    
    private let signInUseCase: SignInUseCaseProtocol
    
    public init(signInUseCase: SignInUseCaseProtocol) {
        self.signInUseCase = signInUseCase
    }
    
//    public init() {
//
//    }
    
    public struct Input {
    }
    
    public struct Output {
        let signInFailure: Signal<Void>
        let signUpSuccess: Signal<Void>
    }
    
    public func trnasform(input: Input) -> Output {
        return Output(signInFailure: signInFailure.asSignal(),
                      signUpSuccess: signUpSuccess.asSignal())
    }
    
    public func setAction(_ actions: SignInViewModelActions) {
        self.actions = actions
    }
    
    public func checkRegistration(uid: String) {
        print("uid \(uid)")
            self.signInUseCase.checkRegistration(uid: uid)
            .debug("checkRegistration")
            .subscribe(with: self, onNext: { owner, isRegistered in
                switch isRegistered {
                case true:
                    owner.signInUseCase.updateFcmToken()
                        .debug("updateFcmToken")
                        .subscribe(onNext: {
                            owner.actions?.finishSignInFeature()
                        })
                        .disposed(by: owner.disposeBag)
                case false:
                    owner.actions?.showSignUpFeature(uid)
                }
            }, onError: { owner, error in
                owner.signInFailure.accept(())
            })
            .disposed(by: self.disposeBag)
            
        }
}
