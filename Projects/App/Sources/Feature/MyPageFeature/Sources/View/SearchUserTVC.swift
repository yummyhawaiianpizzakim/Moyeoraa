//
//  SearchUserTVC.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import RxSwift

public final class SearchUserTVC: MYRSearchUserTVC {
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
    
    public var disposeBag = DisposeBag()
    
    public var isPlusButtonSelected = false {
        didSet {
            self.plusButton.isSelected = self.isPlusButtonSelected
            self.configurePlusButton(self.isPlusButtonSelected)
        }
    }
    
    public lazy var plusButton = MYRIconButton(image: .Moyeora.plus, backgroundColor: .primary(.primary2), cornerRadius: MYRConstants.cornerRadiusSmall)
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.isPlusButtonSelected = false
        self.profileView.image = nil
        self.userNameLabel.setText(with: "")
        self.userTagLabel.setText(with: "")
        self.disposeBag = DisposeBag()
    }
    
    public override func configureAttributes() {
        super.configureAttributes()
        
    }
    
    public override func configureUI() {
        super.configureUI()
        self.configureForSearchUsers()
    }
}

private extension SearchUserTVC {
    func configureForSearchUsers() {
        self.contentView.addSubview(self.mainStackView)
        self.labelStackView.removeFromSuperview()
        [self.labelStackView, self.plusButton].forEach {
            self.mainStackView.addArrangedSubview($0) }
        
        self.mainStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(Metric.trailingMargin)
            make.leading.equalTo(self.profileView.snp.trailing).offset(Metric.stackPadding)
        }
        
        self.labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configurePlusButton(_ isSelected: Bool) {
        self.plusButton.backgroundColor = isSelected ?
            .moyeora(.neutral(.gray4)) :
            .moyeora(.primary(.primary2))
    }
}
 
