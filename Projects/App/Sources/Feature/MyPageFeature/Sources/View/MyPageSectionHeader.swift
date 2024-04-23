//
//  MyPageSectionHeader.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit

public final class MyPageSectionHeader: UIView {
    
    private lazy var titleLabel = MYRLabel("", textColor: .neutral(.gray2), font: .body2)
    
    public init() {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-4)
            make.leading.equalToSuperview()
        }
    }
    
    public func setTitle(_ title: String) {
        self.titleLabel.setText(with: title)
    }
}
