//
//  MYRPlansDetailUserCVC.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/23.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit

public final class MYRPlansDetailUserCVC: UICollectionViewCell {
    private enum Metric {
        static let topMargin = 12
        static let bottomMargin = -topMargin
        static let profileWidth = 48
        static let contentPadding = 8
        static let leadingMargin = 8
        static let trailingMargin = -leadingMargin
        static let cellWidth = 88
        static let cellHeight = 99
    }
    
    private lazy var profileView = MYRIconView(size: .custom(.init(width: Metric.profileWidth, height: Metric.profileWidth)), image: .Moyeora.user, isCircle: true)
    
    private lazy var userName = MYRLabel("", textColor: .neutral(.balck), font: .body1)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MYRPlansDetailUserCVC {
    func configureAttributes() {
        self.contentView.layer.cornerRadius = MYRConstants.cornerRadiusSmall
        self.contentView.layer.borderColor = UIColor.moyeora(.neutral(.gray4)).cgColor
        self.contentView.layer.borderWidth = 1
        self.profileView.backgroundColor = .moyeora(.neutral(.gray5))
        self.userName.numberOfLines = 0
    }
    
    func configureUI() {
        [self.profileView, self.userName].forEach { self.contentView.addSubview($0)
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
            make.bottom.equalToSuperview().offset(Metric.bottomMargin)
        }
    }
}

public extension MYRPlansDetailUserCVC {
    func bindCell(profileURL: String, userName: String) {
        self.profileView.bindImage(urlString: profileURL)
        self.userName.setText(with: userName)
    }
}
