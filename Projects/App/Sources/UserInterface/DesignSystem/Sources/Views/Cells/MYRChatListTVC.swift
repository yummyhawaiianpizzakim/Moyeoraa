//
//  MYRChatListTVC.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/23.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
//import RxSwift
import RxCocoa

public final class MYRChatListTVC: UITableViewCell {
    private enum Metric {
        static let leadingMargin = 12
        static let trailingMargin = -leadingMargin
        static let cellHeight = 76
        static let profileIconWidth = 52
        static let readIconWidth = 16
        static let profilePadding = 12
        static let chatInfoPadding = 12
        static let plansInfoPadding = 4
    }
    
    private lazy var profileView = MYRIconView(size: .custom(.init(width: Metric.profileIconWidth, height: Metric.profileIconWidth)), image: .Moyeora.user, isCircle: true)
    
    private lazy var plansInfoStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = CGFloat(Metric.plansInfoPadding)
        view.distribution = .fillProportionally
        view.axis = .vertical
        return view
    }()
    
    private lazy var chatInfoStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = CGFloat(Metric.chatInfoPadding)
        view.distribution = .fillProportionally
        view.alignment = .trailing
        view.axis = .vertical
        return view
    }()
    
    private lazy var titleLabel = MYRLabel("제목", textColor: .neutral(.balck), font: .body1)
    
    private lazy var locationLabel = MYRLabel("장소", textColor: .neutral(.gray2), font: .body3)
    
    private lazy var dateLabel = MYRLabel("날짜", textColor: .neutral(.gray2), font: .body3)
    
    private lazy var lastSendedTimeLabel = MYRLabel("00:00", textColor: .neutral(.gray4), font: .caption)
    
    private lazy var readIcon = MYRIconView(size: .custom(.init(width: Metric.readIconWidth, height: Metric.readIconWidth)), isCircle: true)
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MYRChatListTVC {
    func configureAttributes() {
        self.selectionStyle = .none
        self.readIcon.backgroundColor = .moyeora(.neutral(.gray4))
        self.profileView.backgroundColor = .moyeora(.neutral(.gray5))
    }
    
    func configureUI() {
        [self.profileView, self.plansInfoStackView,
         self.chatInfoStackView].forEach {
            self.contentView.addSubview($0)
        }
        
        [self.titleLabel, self.locationLabel, self.dateLabel].forEach {
            self.plansInfoStackView.addArrangedSubview($0)
        }
        
        [self.lastSendedTimeLabel, self.readIcon].forEach {
            self.chatInfoStackView.addArrangedSubview($0)
        }
        
        self.profileView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metric.leadingMargin)
            make.centerY.equalToSuperview()
        }
        
        self.plansInfoStackView.snp.makeConstraints { make in
            make.leading.equalTo(self.profileView.snp.trailing).offset(Metric.profilePadding)
            make.centerY.equalToSuperview()
            make.height.equalTo(Metric.profileIconWidth)
        }
        
        self.chatInfoStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(Metric.trailingMargin)
            make.centerY.equalToSuperview()
        }
    }
}

public extension MYRChatListTVC {
    func bindPlansInfo(profileURL: String, title: String, location: String, date: Date) {
        let dateString = date.toStringWithCustomFormat(.yearToMinute)
        self.profileView.bindImage(urlString: profileURL)
        self.titleLabel.setText(with: title)
        self.locationLabel.setText(with: location)
        self.dateLabel.setText(with: dateString)
    }
    
    func bindChatInfo(time: Date, isChecked: Bool) {
        let timeString = time.toStringWithCustomFormat(.hourAndMinute)
        self.lastSendedTimeLabel.setText(with: timeString)
        if isChecked {
            self.readIcon.backgroundColor = .moyeora(.neutral(.gray4))
        } else {
            self.readIcon.backgroundColor = .moyeora(.primary(.primary2))
        }
    }
}
