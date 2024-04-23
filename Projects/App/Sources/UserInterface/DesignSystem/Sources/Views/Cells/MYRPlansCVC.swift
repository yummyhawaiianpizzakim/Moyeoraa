//
//  MYRPlansCVC.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/23.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit

public final class MYRPlansCVC: UICollectionViewCell {
    private enum Metric {
        static let topMargin = 12
        static let bottomMargin = -16
        static let leadingMargin = 12
        static let trailingMargin = -leadingMargin
        static let stackPadding = 8
        static let contentPadding = 4
        static let cellHeight = 106
    }
    
    private lazy var titleLabel = MYRLabel("제목", textColor: .neutral(.balck), font: .subtitle2)
    
    private lazy var plansStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = CGFloat(Metric.contentPadding)
        view.distribution = .fill
        view.alignment = .fill
        view.axis = .vertical
        return view
    }()
    
    private lazy var infoStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = CGFloat(Metric.contentPadding)
        view.distribution = .fill
        view.alignment = .fill
        view.axis = .vertical
        return view
    }()
    
    private lazy var locationLabel = MYRLabel("장소", textColor: .neutral(.balck), font: .body2)
    
    private lazy var timeLabel = MYRLabel("시간", textColor: .neutral(.balck), font: .body2)
    
    private lazy var userLabel = MYRLabel("인원", textColor: .neutral(.balck), font: .body2)
    
    private lazy var locationInfoLabel = MYRLabel("장소", textColor: .neutral(.balck), font: .body3)
    
    private lazy var timeInfoLabel = MYRLabel("00:00", textColor: .neutral(.balck), font: .body3)
    
    private lazy var userInfoLabel = MYRLabel("0명", textColor: .neutral(.balck), font: .body3)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.setText(with: "")
        self.locationInfoLabel.setText(with: "")
        self.timeInfoLabel.setText(with: "")
        self.userInfoLabel.setText(with: "")
    }
}

private extension MYRPlansCVC {
    func configureAttributes() {
        self.contentView.layer.cornerRadius = MYRConstants.cornerRadiusSmall
        self.contentView.layer.borderColor = UIColor.moyeora(.neutral(.balck)).cgColor
        self.contentView.layer.borderWidth = 1
    }
    
    func configureUI() {
        [self.titleLabel, self.plansStackView,
         self.infoStackView,
         ].forEach {
            self.contentView.addSubview($0)
        }
        
        [self.locationLabel, self.timeLabel,
         self.userLabel].forEach {
            self.plansStackView.addArrangedSubview($0)
        }
        
        [self.locationInfoLabel, self.timeInfoLabel,
         self.userInfoLabel].forEach {
            self.infoStackView.addArrangedSubview($0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.topMargin)
            make.leading.equalToSuperview().offset(Metric.leadingMargin)
            make.trailing.equalToSuperview().offset(Metric.trailingMargin)
            make.height.equalTo(16)
        }
        
        self.plansStackView.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(Metric.stackPadding)
            make.leading.equalTo(self.titleLabel.snp.leading)
            make.bottom.equalToSuperview().offset(Metric.bottomMargin)
            make.width.equalTo(26)
        }
        
        self.infoStackView.snp.makeConstraints { make in
            make.top.equalTo(self.plansStackView.snp.top)
            make.leading.equalTo(self.plansStackView.snp.trailing).offset(Metric.stackPadding)
            make.bottom.equalTo(self.plansStackView.snp.bottom)
            make.trailing.equalToSuperview().offset(Metric.trailingMargin)
        }
    }
}

public extension MYRPlansCVC {
    func bindCell(title: String, location: String, time: Date, countUser: Int) {
        let timeString = time.toStringWithCustomFormat("HH:mm")
        self.titleLabel.setText(with: title)
        self.locationInfoLabel.setText(with: location)
        self.timeInfoLabel.setText(with: timeString)
        self.userInfoLabel.setText(with: "\(countUser)명")
    }
}
