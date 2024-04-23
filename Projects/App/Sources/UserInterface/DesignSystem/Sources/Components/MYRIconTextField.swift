//
//  MoyeoraIconTextField.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/19.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit

public final class MYRIconTextField: UITextField {
    override public var placeholder: String? {
        didSet { setNeedsDisplay() }
    }
    
    private var clearButtonWidth: CGFloat {
        clearButtonRect(forBounds: bounds).width
    }
    
    private var iconViewWidth: CGFloat {
        iconView.frame.width
    }
    
    private let iconView: MYRIconView
    
    public init(
        placeholder: String? = "",
        icon: UIImage
    ) {
        let moyeoraIconView = MYRIconView(size: .big, image: icon)
        self.iconView = moyeoraIconView
        super.init(frame: .zero)
        self.configureAttributes()
        self.configureUI()
        self.placeholder = placeholder
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        if didBecomeFirstResponder {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.moyeora(.primary(.primary2)).cgColor
            self.iconView.tintColor = .moyeora(.neutral(.balck))
        }
        return didBecomeFirstResponder
    }
    
    override public func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        if didResignFirstResponder {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.moyeora(.neutral(.balck)).cgColor
            self.iconView.tintColor = .moyeora(.neutral(.balck))
        }
        return didResignFirstResponder
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        setPlaceholderTextColor()
    }
    
    override public func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.clearButtonRect(forBounds: bounds)
        return rect.offsetBy(
            dx: -8,
            dy: 0
        )
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textAreaEdges())
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: textAreaEdges())
    }
}

private extension MYRIconTextField {
    func configureAttributes() {
        self.backgroundColor = .moyeora(.neutral(.white))
        self.font = .moyeora(.subtitle3)
        self.tintColor = .moyeora(.neutral(.balck))
        self.clearButtonMode = .whileEditing
        self.clipsToBounds = true
        self.layer.cornerRadius = MYRConstants.cornerRadiusSmall
        self.isEnabled = true
        self.textColor = .moyeora(.neutral(.balck))
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.moyeora(.neutral(.balck)).cgColor
    }
    
    func configureUI() {
        self.addSubview(self.iconView)
        self.iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(MYRConstants.leadingMarginBig)
            make.centerY.equalToSuperview()
        }
    }
    
    
    func setPlaceholderTextColor() {
        let placeholderTextColor = UIColor.moyeora(.neutral(.gray3))
        
        guard let placeholder else { return }
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: placeholderTextColor
            ]
        )
    }
    
    func textAreaEdges() -> UIEdgeInsets {
        UIEdgeInsets(
            top: 0,
            left:
                MYRConstants.leadingMarginBig
            + self.iconViewWidth
            + MYRConstants.contentSpacing,
            
            bottom: 0,
            right:
                -(MYRConstants.traillingMarginBig)
            + self.clearButtonWidth
            + MYRConstants.contentSpacing
        )
    }
}
