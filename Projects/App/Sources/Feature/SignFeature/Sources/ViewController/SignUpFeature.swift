//
//  SignUpFeature.swift
//  SignFeature
//
//  Created by 김요한 on 2024/04/15.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import FirebaseAuth

public final class SignUpFeature: BaseFeature {
    public let viewModel: SignUpViewModel
    
    private let imageData = BehaviorRelay<Data?>(value: nil)
    
    private lazy var navTitleView = MYRNavigationView(title: "회원가입")
    
    private lazy var descriptionLabel = MYRLabel("프로필 사진과 이름을 입력해주세요.", textColor: .neutral(.balck), font: .subtitle1)
    
    private lazy var editProfileButton: MYRProfileButton = {
        let button = MYRProfileButton(size: .init(width: 96, height: 96))
        return button
    }()
    
    private lazy var imagePicker: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private lazy var nameLabel = MYRLabel("이름", textColor: .neutral(.balck), font: .h2)
    
    private lazy var nameTextField = MYRIconTextField(icon: .Moyeora.edit)
    
    private lazy var doneButton = MYRTextButton("시작하기", textColor: .neutral(.balck), font: .subtitle1, backgroundColor: .primary(.primary2), cornerRadius: 16)
    
    public init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init()
        self.bindUI()
    }
    
    public override func configureAttributes() {
        self.setNavigationBar(isBackButton: true, titleView: self.navTitleView, rightButtonItem: nil)
        
        self.nameTextField.delegate = self
        self.doneButton.isEnabled = false
    }
    
    public override func configureUI() {
        [self.descriptionLabel, self.editProfileButton,
         self.nameLabel, self.nameTextField, self.doneButton].forEach {
            self.view.addSubview($0) }
        
        self.descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(56)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(self.descriptionLabel.snp.bottom).offset(80)
            make.centerX.equalToSuperview()
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.editProfileButton.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        self.nameTextField.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(48)
        }
        
        self.doneButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-24)
            make.height.equalTo(50)
        }
    }
    
    private func bindUI() {
        self.editProfileButton.rx.tap
//            .debug("editProfileButton")
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.present(owner.imagePicker, animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    public override func bindViewModel() {
        let name = self.nameTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .asObservable()
        
        let input = SignUpViewModel.Input(
            name: name,
            profileImage: self.imageData.asObservable(),
            doneButtonDidTap: self.doneButton.rx.tap
                .asObservable()
        )
        
        let output = self.viewModel.trnasform(input: input)
        
        output.doneButtonEnabled.drive(with: self) { owner, isEnabled in
            owner.doneButton.isEnabled = isEnabled
        }
        .disposed(by: self.disposeBag)
        
    }
}


extension SignUpFeature: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage, let data = selectedImage.jpegData(compressionQuality: 0.5) {
            self.editProfileButton.profileView.image = selectedImage
            self.imageData.accept(data)
        }
        
        self.dismiss(animated: true)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}

extension SignUpFeature: UITextFieldDelegate {
}
