//
//  MoyeoraIconButton.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/19.
//  Copyright © 2024 Moyeora. All rights reserved.
//
import UIKit

public final class MYRIconButton: UIButton {
    public override var isEnabled: Bool {
        didSet { self.setButton(self.isEnabled)}
    }
    
    public init(image: UIImage?,
                backgroundColor: UIColor.MYRColorSystem = .primary(.primary2),
                cornerRadius: CGFloat = MYRConstants.cornerRadiusSmall
    ) {
        super.init(frame: .zero)
        self.setImage(image, for: .normal)
        self.backgroundColor = .moyeora(backgroundColor)
        self.layer.cornerRadius = cornerRadius
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MYRIconButton {
    func setButton(_ isEnabled: Bool) {
        if isEnabled {
            self.backgroundColor = .moyeora(.primary(.primary2))
        } else {
            self.backgroundColor = .moyeora(.neutral(.gray4))
        }
    }
}
