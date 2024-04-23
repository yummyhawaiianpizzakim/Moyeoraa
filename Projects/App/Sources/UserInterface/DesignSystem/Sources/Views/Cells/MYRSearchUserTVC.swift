//
//  MYRSearchUserTVC.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/24.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

open class MYRSearchUserTVC: UITableViewCell {
    public enum Metric {
        static let leadingMargin = 16
        static let trailingMargin = -leadingMargin
        static let stackPadding = 16
        static let buttonPadding = 4
        static let cellHeight = 80
        static let profileIconWidth = 48
        static let plusIconWidth = 24
        static let blockIconWidth = 64
        static let blockIconHeight = 34
    }
    
    public lazy var labelStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = CGFloat(Metric.stackPadding)
        view.distribution = .equalSpacing
        view.alignment = .center
        view.axis = .horizontal
        return view
    }()
    
    public lazy var mainStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = CGFloat(Metric.stackPadding)
        view.distribution = .equalCentering
        view.alignment = .center
        view.axis = .horizontal
        return view
    }()
    
    public lazy var profileView = MYRIconView(size: .custom(.init(width: Metric.profileIconWidth, height: Metric.profileIconWidth)), image: .Moyeora.user, isCircle: true)
    
    public lazy var userNameLabel = MYRLabel("이름", textColor: .neutral(.balck), font: .body1)
    
    public lazy var userTagLabel = MYRLabel("#1234", textColor: .neutral(.gray2), font: .body3)
   
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureAttributes()
        self.configureUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configureAttributes() {
        self.selectionStyle = .none
        self.profileView.backgroundColor = .moyeora(.neutral(.gray5))
    }
    
    open func configureUI() {
        [self.profileView, self.labelStackView].forEach {
            self.contentView.addSubview($0)
        }
        
        [self.userNameLabel, self.userTagLabel].forEach {
            self.labelStackView.addArrangedSubview($0)
        }
        
        self.profileView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metric.leadingMargin)
            make.centerY.equalToSuperview()
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.profileView.snp.trailing).offset(Metric.stackPadding)
            make.centerY.equalToSuperview()
        }
    }
    
    open func bindCell(profileURL: String, userName: String, userTag: Int) {
        self.profileView.bindImage(urlString: profileURL)
        self.userNameLabel.setText(with: userName)
        self.userTagLabel.setText(with: "#\(userTag)")
    }
}

public extension MYRSearchUserTVC {

}
