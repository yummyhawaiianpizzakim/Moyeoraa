//
//  MYRNotificationTVC.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/22.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public final class MYRNotificationTVC: UITableViewCell {
    private enum Metric {
        static let leadingMargin = MYRConstants.leadingMarginBig
        static let trailingMargin = -leadingMargin
        static let padding = 12
    }
    
    private lazy var icon = MYRIconView(size: .big, image: .Moyeora.bell)
    
    private lazy var label = MYRLabel("알람 설정", textColor: .neutral(.balck), font: .body1)
    
    private lazy var notificationSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.onTintColor = .moyeora(.primary(.primary2))
        return uiSwitch
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MYRNotificationTVC {
    func configureAttributes() {
        self.selectionStyle = .none
    }
    
    func configureUI() {
        [self.icon, self.label,
         self.notificationSwitch].forEach { view in
            self.contentView.addSubview(view)
        }
        
        self.icon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metric.leadingMargin)
            make.centerY.equalToSuperview()
        }
        
        self.label.snp.makeConstraints { make in
            make.leading.equalTo(self.icon.snp.trailing).offset(Metric.padding)
            make.centerY.equalToSuperview()
        }
        
        self.notificationSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(Metric.trailingMargin)
            make.centerY.equalToSuperview()
        }
    }
}

public extension MYRNotificationTVC {
    func bindSwitch(_ isNotification: Bool) {
        self.notificationSwitch.isOn = isNotification
    }
    
    var isNotificationDidChange: Observable<Bool> {
        return self.notificationSwitch.rx
            .controlEvent(.valueChanged).asObservable()
            .withUnretained(self)
            .map { owner, _ in
                owner.notificationSwitch.isOn
            }
    }
}
