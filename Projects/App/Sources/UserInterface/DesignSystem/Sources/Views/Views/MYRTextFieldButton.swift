//
//  MoyeoraTextFieldButton.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/19.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit

public final class MYRTextFieldButton: UIButton {
    
    private let innerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private var iconView = MYRIconView()
    
    private var label = UITextField()
    
    private let chevronIconView = MYRIconView(size: .big, image: .Moyeora.chevronRight)
    
    public init(text: String, icon: UIImage) {
        super.init(frame: .zero)
        self.configureAttributes(text: text, icon: icon)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

public extension MYRTextFieldButton {
    func setText(text: String) {
        self.label.text = text
    }
}

private extension MYRTextFieldButton {
    func configureAttributes(text: String, icon: UIImage) {
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = MYRConstants.cornerRadiusSmall
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.moyeora(.neutral(.balck)).cgColor
        self.label.isEnabled = false
        self.label.placeholder = text
        let iconView = MYRIconView(size: .big, image: icon)
        self.iconView = iconView
    }
    
    func configureUI() {
        self.addSubview(self.stackView)
        [self.iconView, self.label, self.chevronIconView].forEach { view in
            self.stackView.addArrangedSubview(view)
        }
        
        self.stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(MYRConstants.leadingMarginBig).priority(999)
            make.trailing.equalToSuperview().offset(MYRConstants.traillingMarginSmall).priority(999)
            make.centerY.equalToSuperview().priority(999)
        }
    }
}
