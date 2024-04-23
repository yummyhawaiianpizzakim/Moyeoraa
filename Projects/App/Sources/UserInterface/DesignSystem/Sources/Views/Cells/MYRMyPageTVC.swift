//
//  MYRMyPageTVC.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/22.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public final class MYRMyPageTVC: UITableViewCell {
    public enum CellType {
        case leftRightIcon(title: String, left: UIImage, right: UIImage)
        case leftIcon(title: String, left: UIImage)
        case labelOnly(title: String, content: String)
    }
    
    private enum Metric {
        static let leadingMargin = MYRConstants.leadingMarginBig
        static let trailingMargin = -leadingMargin
        static let padding = 12
    }
    
    private lazy var leftIcon = MYRIconView()
    
    private lazy var titleLabel = MYRLabel("")
    
    private lazy var contentLabel = MYRLabel("")
    
    private lazy var rightIcon = MYRIconView()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureAttributes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MYRMyPageTVC {
    func configureAttributes() {
        self.selectionStyle = .none
    }
    
    func configureInitUI(title: String? = nil, left: UIImage? = nil, right: UIImage? = nil, content: String? = nil) {
        title.flatMap { [weak self] title in
            self?.titleLabel = MYRLabel(title, textColor: .neutral(.balck), font: .body1)
        }
        left.flatMap { [weak self] image in
            self?.leftIcon = MYRIconView(image: image)
        }
        right.flatMap { [weak self] image in
            self?.rightIcon = MYRIconView(image: image)
        }
        content.flatMap { [weak self] content in
            self?.contentLabel = MYRLabel(content, textColor: .neutral(.gray3), font: .body3)
        }
    }
    
    func configureUIWhenLabelOnly(_ title: String, _ content: String) {
        self.configureInitUI(title: title, content: content)
        
        [self.titleLabel, self.contentLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metric.leadingMargin)
            make.centerY.equalToSuperview()
        }
        
        self.contentLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(Metric.trailingMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureUIWhenLeftRightIcon(_ title: String, _ left: UIImage, _ right: UIImage) {
        self.configureInitUI(title: title, left: left, right: right)
        
        [self.titleLabel, self.leftIcon, self.rightIcon].forEach {
            self.contentView.addSubview($0)
        }
        
        self.leftIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metric.leadingMargin)
            make.centerY.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.leftIcon.snp.trailing).offset(Metric.padding)
            make.centerY.equalToSuperview()
        }
        
        self.rightIcon.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(Metric.trailingMargin)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureUIWhenLeftIcon(_ title: String, _ left: UIImage) {
        self.configureInitUI(title: title, left: left)
        
        [self.titleLabel, self.leftIcon].forEach {
            self.contentView.addSubview($0)
        }
        
        self.leftIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metric.leadingMargin)
            make.centerY.equalToSuperview()
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.leftIcon.snp.trailing).offset(Metric.padding)
            make.centerY.equalToSuperview()
        }
    }
}

public extension MYRMyPageTVC {
    func setCell(cellType: CellType) {
        switch cellType {
        case .leftRightIcon(title: let title, left: let left, right: let right):
            self.configureUIWhenLeftRightIcon(title, left, right)
        case .leftIcon(title: let title, left: let left):
            self.configureUIWhenLeftIcon(title, left)
        case .labelOnly(title: let title, content: let content):
            self.configureUIWhenLabelOnly(title, content)
        }
    }
}
