//
//  MYRMapUserCVC.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/24.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit

public final class MYRMapUserCVC: UICollectionViewCell {
    private enum Metric {
        static let topMargin = 12
        static let bottomMargin = -topMargin
        static let profileWidth = 48
        static let contentPadding = 8
        static let leadingMargin = 8
        static let trailingMargin = -leadingMargin
        static let cellWidth = 88
        static let cellHeight = 126
    }
    
    private var isArrived: Bool = false {
        didSet { self.setArrivedStateLabel(isArrived)}
    }
    
    private lazy var profileView = MYRIconView(size: .custom(.init(width: Metric.profileWidth, height: Metric.profileWidth)), image: .Moyeora.user, isCircle: true)
    
    private lazy var userName = MYRLabel("", textColor: .neutral(.balck), font: .body1)
    
    private lazy var arrivedStateLabel = MYRLabel("이동중", textColor: .primary(.primary2), font: .body1)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MYRMapUserCVC {
    func configureAttributes() {
        self.contentView.layer.cornerRadius = MYRConstants.cornerRadiusSmall
        self.contentView.layer.borderColor = UIColor.moyeora(.neutral(.gray4)).cgColor
        self.contentView.layer.borderWidth = 1
        self.profileView.backgroundColor = .moyeora(.neutral(.gray5))
        self.userName.numberOfLines = 1
        self.arrivedStateLabel.numberOfLines = 1
        self.arrivedStateLabel.textAlignment = .center
    }
    
    func configureUI() {
        [self.profileView, self.userName,
         self.arrivedStateLabel].forEach { self.contentView.addSubview($0)
        }
        
        self.profileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.topMargin)
            make.centerX.equalToSuperview()
        }
        
        self.userName.snp.makeConstraints { make in
            make.top.equalTo(self.profileView.snp.bottom).offset(Metric.contentPadding)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(Metric.leadingMargin)
            make.trailing.equalToSuperview().offset(Metric.trailingMargin)
        }
        
        self.arrivedStateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.userName.snp.bottom).offset(Metric.contentPadding)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(Metric.leadingMargin)
            make.trailing.equalToSuperview().offset(Metric.trailingMargin)
            make.bottom.equalToSuperview().offset(Metric.bottomMargin)
        }
    }
    
    func setArrivedStateLabel(_ isArrived: Bool) {
        if isArrived {
            self.arrivedStateLabel.myrTextColor = .neutral(.gray2)
            self.arrivedStateLabel.setText(with: "도착")
            self.arrivedStateLabel.textAlignment = .center
        } else {
            self.arrivedStateLabel.myrTextColor = .primary(.primary2)
            self.arrivedStateLabel.setText(with: "이동중")
            self.arrivedStateLabel.textAlignment = .center
        }
    }
}

public extension MYRMapUserCVC {
    func bindCell(profileURL: String, userName: String) {
        self.profileView.bindImage(urlString: profileURL)
        self.userName.setText(with: userName)
    }
    
    func bindIsArrived(_ isArrived: Bool) {
        self.isArrived = isArrived
    }
}
