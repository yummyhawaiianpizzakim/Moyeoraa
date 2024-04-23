//
//  MYRAlertController.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/22.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public final class MYRAlertController: UIAlertController {
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAttributes()
    }
    
    // MARK: - Functions
    
    public override func addAction(_ action: UIAlertAction) {
        switch action.style {
        case .cancel:
            action.setValue(UIColor.moyeora(.neutral(.gray3)), forKey: "titleTextColor")
        case .default:
            action.setValue(UIColor.moyeora(.primary(.primary1)), forKey: "titleTextColor")
        case .destructive:
            action.setValue(UIColor.moyeora(.system(.error)), forKey: "titleTextColor")
        default: break
        }
        
        super.addAction(action)
    }
    
    public func addActions(_ actions: [UIAlertAction]) {
        actions.forEach {
            self.addAction($0)
        }
    }
}

// MARK: - Setup Functions

private extension MYRAlertController {
    
    func configureAttributes() {
        setAlertBackgroundColor()
        setAlertTitleFont()
        setAlertMessageFont()
    }
    
    func setAlertBackgroundColor() {
        view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .moyeora(.neutral(.gray5))
    }
    
    func setAlertTitleFont() {
        let titleAttributes = attributedString(from: .subtitle2)
        let titleString = NSAttributedString(string: title ?? "", attributes: titleAttributes)
        
        self.setValue(titleString, forKey: "attributedTitle")
        
    }
    
    func setAlertMessageFont() {
        let messageAttributes = attributedString(from: .body3)
        let messageString = NSAttributedString(string: message ?? "", attributes: messageAttributes)
        
        self.setValue(messageString, forKey: "attributedMessage")
    }
    
    func attributedString(from font: UIFont.MYRFontSystem) -> [NSAttributedString.Key: Any] {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = font.lineHeight
        paragraph.alignment = .center
        
        return [
            NSAttributedString.Key.font: font.font,
            NSAttributedString.Key.foregroundColor: UIColor.moyeora(.neutral(.balck)),
            NSAttributedString.Key.kern: font.letterSpacing,
            NSAttributedString.Key.paragraphStyle: paragraph
        ] as [NSAttributedString.Key: Any]
    }
}
