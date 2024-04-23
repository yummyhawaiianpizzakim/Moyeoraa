//
//  BlockUserTVC.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/02.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

public final class BlockUserTVC: MYRSearchUserTVC {
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
    
    public var isBlockButtonSelected = false {
        didSet {
            self.blockButton.isSelected = self.isBlockButtonSelected
            self.configureBlockButton(self.isBlockButtonSelected)
        }
    }
    
    public lazy var blockButton = MYRTextButton("차단해제", textColor: .neutral(.balck), font: .body3, backgroundColor: .system(.error), cornerRadius: MYRConstants.cornerRadiusMedium)
    
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
        self.isBlockButtonSelected = false
        self.profileView.image = nil
        self.userNameLabel.setText(with: "")
        self.userTagLabel.setText(with: "")
        self.disposeBag = DisposeBag()
    }
    
    public override func configureAttributes() {
        super.configureAttributes()
        self.blockButton.setTitle("차단해제", for: .normal)
        self.blockButton.setTitle("차단하기", for: .selected)
    }
    
    public override func configureUI() {
        super.configureUI()
        self.configureForBlock()
    }
}

private extension BlockUserTVC {
    func configureForBlock() {
        self.contentView.addSubview(self.mainStackView)
        self.labelStackView.removeFromSuperview()
        [self.labelStackView, self.blockButton].forEach {
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
        
        self.blockButton.snp.makeConstraints { make in
            make.width.equalTo(Metric.blockIconWidth)
            make.height.equalTo(Metric.blockIconHeight)
        }
    }
    
    private func configureBlockButton(_ isSelected: Bool) {
        self.blockButton.backgroundColor = isSelected ?
            .moyeora(.neutral(.gray4)) :
            .moyeora(.system(.error))
    }
}
 
