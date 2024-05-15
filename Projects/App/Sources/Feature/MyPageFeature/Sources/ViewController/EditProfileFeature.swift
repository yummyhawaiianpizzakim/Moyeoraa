//
//  EditProfileFeature.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

public final class EditProfileFeature: BaseFeature {
    private let viewModel: EditProfileViewModel
    
    private let imageData = BehaviorRelay<Data?>(value: nil)
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        activityIndicator.color = .moyeora(.neutral(.gray4))
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private let titleView = MYRNavigationView(title: "프로필 편집")
    
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
    
    private lazy var doneButton = MYRTextButton("수정하기", textColor: .neutral(.balck), font: .subtitle1, backgroundColor: .primary(.primary2), cornerRadius: 16)
    
    public init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init()
        self.bindUI()
    }
    
    public override func configureAttributes() {
        self.nameTextField.delegate = self
        self.setNavigationBar(isBackButton: true, titleView: self.titleView, rightButtonItem: nil, isSetTitleViewOnCenter: true)
        self.view.backgroundColor = .white
    }
    
    public override func configureUI() {
        [self.editProfileButton, self.nameLabel,
         self.nameTextField, self.doneButton].forEach {
            self.view.addSubview($0) }
        
        self.editProfileButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(56)
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
    
    func bindUI() {
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
            .asObservable()
        
        let doneButtonDidTap = self.doneButton.rx.tap
            .do(onNext: { [weak self] _ in
                self?.activityIndicator.startAnimating()
            })
            .asObservable()
        
        let input = EditProfileViewModel.Input(
            viewDidAppear: self.rx.viewDidAppear.map { _ in () }.asObservable(),
            name: name,
            profileImage: self.imageData.asObservable(),
            doneButtonDidTap: doneButtonDidTap
        )
        
        let output = self.viewModel.trnasform(input: input)
        
        output.defaultUser.drive(with: self) { owner, user in
            owner.editProfileButton.bindImage(urlString: user.profileImage ?? "")
            owner.nameTextField.text = user.name
            owner.doneButton.isEnabled = false
        }
        .disposed(by: self.disposeBag)
        
        output.doneButtonEnabled.drive(with: self) { owner, isEnabled in
            owner.doneButton.isEnabled = isEnabled
        }
        .disposed(by: self.disposeBag)
        
        output.result
            .subscribe(with: self) { owner, _ in
                print("success")
                owner.activityIndicator.stopAnimating()
                owner.viewModel.actions?.finishEditProfileFeature()
            } onError: { owner, error in
                print("\(error)")
                owner.activityIndicator.stopAnimating()
                let toastView = MYRToastView(type: .failure, message: "프로필 수정이 실패했습니다 나중에 다시 시도해 주세요", followsUndockedKeyboard: true)
                toastView.show(in: self.view)
            }
            .disposed(by: self.disposeBag)
    }
}

extension EditProfileFeature: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
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

extension EditProfileFeature: UITextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = self.viewModel.defaultName
        }
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == self.viewModel.defaultName {
            textField.text = ""
        }
    }
}
