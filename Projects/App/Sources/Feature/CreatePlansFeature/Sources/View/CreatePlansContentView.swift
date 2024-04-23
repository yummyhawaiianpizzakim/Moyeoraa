//
//  CreatePlansContentView.swift
//  CreatePlansFeature
//
//  Created by 김요한 on 2024/04/05.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public final class CreatePlansContentView: UIView {
    private lazy var titleStackView = self.createStackView(spacing: 8)
    
    private lazy var dateStackView = self.createStackView(spacing: 8)
    
    private lazy var locationStackView = self.createStackView(spacing: 8)
    
    private lazy var memberStackView = self.createStackView(spacing: 8)
    
    private lazy var titleLabel = MYRLabel("제목*", textColor: .neutral(.balck), font: .h2)
    
    private lazy var dateLabel = MYRLabel("날짜*", textColor: .neutral(.balck), font: .h2)
    
    private lazy var locationLabel = MYRLabel("장소*", textColor: .neutral(.balck), font: .h2)
    
    private lazy var memberLabel = MYRLabel("맴버", textColor: .neutral(.balck), font: .h2)
    
    public lazy var titleTextField = MYRIconTextField(placeholder: "제목을 입력해주세요.", icon: .Moyeora.edit)
    
    public lazy var dateButton = MYRTextFieldButton(text: "원하는 날짜를 입력해주세요.", icon: .Moyeora.calendar)
    
    public lazy var locationButton = MYRTextFieldButton(text: "원하는 장소를 입력해주세요.", icon: .Moyeora.map)
    
    public lazy var memberButton = MYRTextFieldButton(text: "같이 만날 사용자를 입력해주세요.", icon: .Moyeora.user)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAttributes()
        self.configureUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureAttributes() {
        
    }
    
    public func configureUI() {
        [self.titleStackView, self.dateStackView,
         self.locationStackView, self.memberStackView
        ]
            .forEach { self.addSubview($0) }
        
        [self.titleLabel, self.titleTextField].forEach { self.titleStackView.addArrangedSubview($0) }
        
        [self.dateLabel, self.dateButton].forEach { self.dateStackView.addArrangedSubview($0) }
        
        [self.locationLabel, self.locationButton].forEach { self.locationStackView.addArrangedSubview($0) }
        
        [self.memberLabel, self.memberButton].forEach { self.memberStackView.addArrangedSubview($0) }
        
        self.titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(88)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.dateStackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.locationStackView.snp.makeConstraints { make in
            make.top.equalTo(self.dateStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.memberStackView.snp.makeConstraints { make in
            make.top.equalTo(self.locationStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        self.titleTextField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        self.dateButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        self.locationButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        self.memberButton.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(550)
        }
    }
    
    func createStackView(spacing: CGFloat) -> UIStackView {
        let view = UIStackView()
        view.spacing = spacing
        view.alignment = .fill
        view.distribution = .fillProportionally
        view.axis = .vertical
        return view
    }
}
