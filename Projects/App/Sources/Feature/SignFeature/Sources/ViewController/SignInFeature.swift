//
//  SignInFeature.swift
//  SignFeatureInterface
//
//  Created by 김요한 on 2024/04/15.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FirebaseAuth
import AuthenticationServices

public final class SignInFeature: BaseFeature {
    public let viewModel: SignInViewModel
    
    fileprivate var currentNonce: String?
    private let credential = PublishRelay<(Data, Data)>()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        activityIndicator.color = .moyeora(.neutral(.gray4))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var logoImageView = MYRIconView(size: .custom(.init(width: 128, height: 152)), image: .Moyeora.moyeoraLogo)
    
    private lazy var appleSignInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        return button
    }()
    
    private lazy var privacyPolicyButton = MYRTextButton("개인정보처리방침", textColor: .neutral(.balck), font: .caption, backgroundColor: .neutral(.white), cornerRadius: 0)
    
    public init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init()
        self.bindUI()
    }
    
    public override func configureAttributes() {
        
    }
    
    public override func configureUI() {
        [self.logoImageView, self.appleSignInButton, self.privacyPolicyButton]
            .forEach { self.view.addSubview($0) }
        
        self.logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        
        self.appleSignInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(25)
            make.height.equalTo(48)
            make.top.equalTo(logoImageView.snp.centerY).multipliedBy(1.9)
        }
        
        self.privacyPolicyButton.snp.makeConstraints { make in
            make.top.equalTo(appleSignInButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }
        
    }
    
    private func bindUI() {
        self.privacyPolicyButton.rx.tap
            .subscribe(with: self) { owner, _ in
                owner.openPrivacyPolicy()
            }
            .disposed(by: self.disposeBag)
    }
    
    public override func bindViewModel() {
        self.appleSignInButton.rx.controlEvent(.touchUpInside)
            .subscribe(with: self) { owner, _ in
                owner.loginButtonDidTap()
            }
            .disposed(by: self.disposeBag)
        
        let input = SignInViewModel.Input(
            
        )
        
        let output = self.viewModel.trnasform(input: input)
            
        output.signInFailure
            .emit(with: self) { owner, _ in
                let toastView = MYRToastView(type: .failure, message: "로그인에 실패했습니다. 나중에 다시해주세요.", followsUndockedKeyboard: false)
                toastView.show(in: self.view)
            }
            .disposed(by: self.disposeBag)
    }
}

private extension SignInFeature {
    func generateOAuthCredential(authorization: ASAuthorization) -> (OAuthCredential, String)? {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let nonce = generateRandomNonce().toSha256()
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return nil
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return nil
            }
            
            guard
                let authorizationCode = appleIDCredential.authorizationCode,
                let codeString = String(data: authorizationCode, encoding: .utf8)
            else {
                print("Unable to serialize token string from authorizationCode")
                return nil
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            return (credential, codeString)
        }
        return nil
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func generateRandomNonce(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func openPrivacyPolicy() {
        guard let url = URL(string: "asdkf") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

extension SignInFeature: ASAuthorizationControllerDelegate {
    func loginButtonDidTap() {
        let nonce = self.generateRandomNonce()
        self.currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = nonce.toSha256()
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    public func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let nonce = self.currentNonce,
              let appleIDToken = appleIDCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else { return }
        
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let user = authResult?.user {
                self.viewModel.checkRegistration(uid: user.uid)
            }
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
}

extension SignInFeature: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(
        for _: ASAuthorizationController
    ) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
}
