//
//  ChatTVC.swift
//  ChatFeature
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxRelay
import RxSwift

public final class ChatTVC: UITableViewCell {
    private enum Metric {
        static let leadingMargin = 12
        static let trailingMargin = -leadingMargin
        static let bottomMargin = -8
        static let mineTopMargin = 8
        static let otherTopMargin = 0
    }
    
    public var disposeBag = DisposeBag()
    
    private lazy var profileImageView = MYRIconView(size: .custom(.init(width: 34, height: 34)), isCircle: true)
    
    private lazy var chatContentView = ChatContentView()
    
    private lazy var chatLabel = MYRLabel("", font: .body3)
    
    // MARK: - Initializer
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
        self.profileImageView.image = nil
    }
    
    private func configureAttributes() {
        self.backgroundColor = .clear
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.chatLabel.numberOfLines = 0
    }
    
    private func configureUI() {
        [self.profileImageView, self.chatContentView]
            .forEach { self.contentView.addSubview($0) }
        
        self.chatContentView.addSubview(self.chatLabel)
        
        self.profileImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(8)
            make.width.height.equalTo(34)
        }
        
        self.chatLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        self.configureLayoutAsOther(hasMyChatBefore: false)
    }
    
    public func bindCell(by chat: Chat, hasMyChatBefore: Bool, completion: (() -> Void)? = nil) {
        self.profileImageView.bindImage(urlString: chat.user?.profileImage ?? "")
        self.chatContentView.sender = chat.senderType
        self.chatLabel.text = chat.content
        self.reconfigureLayout(
            by: chat.senderType,
            hasMyChatBefore: hasMyChatBefore
        )
        completion?()
    }
}

// MARK: - Privates
private extension ChatTVC {
    
    private func reconfigureLayout(
        by senderType: Chat.SenderType,
        hasMyChatBefore: Bool
    ) {
        if senderType == .mine {
            self.configureLayoutAsMine(hasMyChatBefore: hasMyChatBefore)
        } else {
            self.configureLayoutAsOther(hasMyChatBefore: hasMyChatBefore)
        }
    }
    
    private func configureLayoutAsMine(hasMyChatBefore: Bool) {
        self.profileImageView.isHidden = true
        let topInset = topInset(when: hasMyChatBefore)
        self.chatContentView.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().offset(Metric.trailingMargin)
            make.leading.greaterThanOrEqualToSuperview().offset(100)
            make.bottom.equalToSuperview().offset(Metric.bottomMargin)
            make.top.equalToSuperview().inset(topInset)
        }
    }
    
    private func configureLayoutAsOther(hasMyChatBefore: Bool) {
        self.profileImageView.isHidden = hasMyChatBefore
        let topInset = topInset(when: hasMyChatBefore)
        self.chatContentView.snp.remakeConstraints { make in
            make.leading.equalTo(self.profileImageView.snp.trailing).offset(Metric.leadingMargin)
            make.trailing.lessThanOrEqualToSuperview().offset(-100)
            make.bottom.equalToSuperview().offset(Metric.bottomMargin)
            make.top.equalToSuperview().inset(topInset)
        }
    }
    
    private func topInset(when hasMyChatBefore: Bool) -> CGFloat {
        if hasMyChatBefore {
            return CGFloat(Metric.otherTopMargin)
        } else {
            return CGFloat(Metric.mineTopMargin)
        }
    }
}
