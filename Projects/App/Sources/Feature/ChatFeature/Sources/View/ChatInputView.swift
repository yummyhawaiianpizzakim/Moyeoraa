//
//  ChatInputView.swift
//  ChatFeature
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

public final class ChatInputView: UIView {
    private let disposeBag = DisposeBag()
    
    private lazy var chatTextField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .none
        textField.font = .moyeora(.body3)
        textField.placeholder = "메세지를 입력해주세요."
        return textField
    }()
    
    private lazy var mapButton = MYRIconButton(image: .Moyeora.map, backgroundColor: .neutral(.white), cornerRadius: MYRConstants.cornerRadiusMedium)
    
    private lazy var sendChatButton: MYRIconButton = {
        let button = MYRIconButton(image: .Moyeora.arrowUp, backgroundColor: .neutral(.gray4), cornerRadius: 20)
        return button
    }()
    
    private lazy var chatInputContainerView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.moyeora(.neutral(.gray4)).cgColor
        view.layer.borderWidth = 1
        
        return view
    }()
    
    public init() {
        super.init(frame: .zero)
        self.configureUI()
        self.bindView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        let inputContainerViewCornerRadius = self.chatInputContainerView.frame.height / 2
        self.chatInputContainerView.layer.cornerRadius = inputContainerViewCornerRadius
    }
    
    public func configureUI() {
        self.addSubview(self.chatInputContainerView)
        
        [self.chatTextField, self.mapButton, self.sendChatButton].forEach {
            self.chatInputContainerView.addSubview($0)
        }
        
        self.chatInputContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        self.chatTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        self.sendChatButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-4)
            make.height.width.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        self.mapButton.snp.makeConstraints { make in
            make.leading.equalTo(chatTextField.snp.trailing).offset(8)
            make.trailing.equalTo(sendChatButton.snp.leading).offset(-8)
            make.height.width.equalTo(40)
            make.centerY.equalToSuperview()
        }
    }
    
    public func bindView() {
        self.chatTextField.rx.text
            .orEmpty
            .map(\.isEmpty)
            .map { !$0 }
            .bind(to: sendChatButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: - Rx Observers
public extension ChatInputView {
    
    var mapButtonDidTap: Observable<Void> {
        return mapButton.rx.tap.asObservable()
    }
    
    var sendButtonDidTapWithText: Observable<String> {
        return sendChatButton.rx.tap
//            .debug("sendChatButton")
            .withUnretained(self) { owner, _ in
                let text = owner.chatTextField.text ?? ""
                
                owner.chatTextField.text = ""
                owner.sendChatButton.isEnabled = false
                return text
            }
            .asObservable()
    }
}
