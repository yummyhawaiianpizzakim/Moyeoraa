//
//  MoyeoraLabel.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/19.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class MYRLabel: UILabel {
    public var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    private var myrText: String
    private var myrFont: UIFont.MYRFontSystem
    public var myrTextColor: UIColor.MYRColorSystem
    
    
    override public var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
    
    public init(
        _ title: String = "",
        textColor: UIColor.MYRColorSystem = .neutral(.balck),
        font: UIFont.MYRFontSystem = .subtitle2
    ) {
        self.myrText = title
        self.myrFont = font
        self.myrTextColor = textColor
        super.init(frame: .zero)
        self.setupAttributes()
    }

    override public func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    private func setupAttributes() {
        let attributedString = NSMutableAttributedString(string: self.myrText)
        let range = (self.myrText as NSString).range(of: self.myrText)
        
        attributedString.addAttribute(
            .font,
            value: self.myrFont.font,
            range: range
        )
        
        attributedString.addAttribute(
            .foregroundColor,
            value: UIColor.moyeora(self.myrTextColor),
            range: range
        )
        
        attributedString.addAttribute(
            .kern,
            value: self.myrFont.letterSpacing,
            range: range
        )
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = self.myrFont.lineHeight
        
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraph,
            range: range
        )
        
        self.attributedText = attributedString
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension MYRLabel {
    func setText(with text: String) {
        self.myrText = text
        self.setupAttributes()
    }
}
