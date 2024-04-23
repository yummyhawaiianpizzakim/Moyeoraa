//
//  LocationTVC.swift
//  CreatePlansFeature
//
//  Created by 김요한 on 2024/04/08.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

public final class LocationTVC: UITableViewCell {
    public var disposeBag = DisposeBag()
    
    private lazy var labelStackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 4
        view.alignment = .fill
        view.axis = .vertical
        view.distribution = .fill
        return view
    }()
    
    private lazy var addressLabel = MYRLabel("", textColor: .neutral(.balck), font: .body1)
    
    private lazy var fullAddressLabel = MYRLabel("", textColor: .neutral(.gray3), font: .body3)
    
    // MARK: - Initializer
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        self.disposeBag = DisposeBag()
        self.addressLabel.setText(with: "")
        self.fullAddressLabel.setText(with: "")
    }
    
    private func configureAttributes() {
        self.backgroundColor = .clear
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addressLabel.numberOfLines = 1
        self.fullAddressLabel.numberOfLines = 1
    }
    
    private func configureUI() {
        self.contentView.addSubview(self.labelStackView)
        [self.addressLabel, self.fullAddressLabel]
            .forEach { self.labelStackView.addArrangedSubview($0) }
        
        self.labelStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(16)
        }
        
    }
    
    public func bindCell(address: String, fullAdd: String) {
        self.addressLabel.setText(with: address)
        self.fullAddressLabel.setText(with: fullAdd)
    }
}
