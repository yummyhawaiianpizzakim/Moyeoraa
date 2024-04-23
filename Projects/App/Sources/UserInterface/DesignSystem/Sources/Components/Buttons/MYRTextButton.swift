//
//  MoyeoraTextButton.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/19.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class MYRTextButton: UIButton {
    public override var isEnabled: Bool {
        didSet { self.setButton(self.isEnabled)}
    }
    
    public init(
        _ text: String = "",
        textColor: UIColor.MYRColorSystem = .neutral(.balck),
        font: UIFont.MYRFontSystem = .subtitle2,
        backgroundColor: UIColor.MYRColorSystem = .primary(.primary2),
        cornerRadius: CGFloat = MYRConstants.cornerRadiusMedium
    ) {
        super.init(frame: .zero)
        self.setTitle(text, for: .normal)
        self.setTitleColor(.moyeora(textColor), for: .normal)
        self.setTitleColor(.moyeora(textColor).withAlphaComponent(0.7), for: .highlighted)
        self.titleLabel?.font = .moyeora(font)
        self.imageView?.tintColor = .moyeora(textColor)
        self.backgroundColor = .moyeora(backgroundColor)
        self.layer.cornerRadius = cornerRadius
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MYRTextButton {
    func setButton(_ isEnabled: Bool) {
        if isEnabled {
            self.backgroundColor = .moyeora(.primary(.primary2))
        } else {
            self.backgroundColor = .moyeora(.neutral(.gray4))
        }
    }
}
