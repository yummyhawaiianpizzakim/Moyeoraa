//
//  Font+.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/18.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

protocol MYRFontable {
    var font: UIFont { get }
}

public extension UIFont {
    enum MYRFontSystem: MYRFontable {
        case h1
        case h2
        case subtitle1
        case subtitle2
        case subtitle3
        case body1
        case body2
        case body3
        case body4
        case caption
    }

    static func moyeora(_ style: MYRFontSystem) -> UIFont {
        return style.font
    }
}

public extension UIFont.MYRFontSystem {
    var font: UIFont {
        switch self {
        case .h1:
            return UIFont(font: MoyeoraaFontFamily.Pretendard.semiBold, size: 24) ?? .init()
        case .h2:
            return UIFont(font: MoyeoraaFontFamily.Pretendard.semiBold, size: 20) ?? .init()
        case .subtitle1:
            return UIFont(font: MoyeoraaFontFamily.Pretendard.semiBold, size: 18) ?? .init()
        case .subtitle2:
            return UIFont(font: MoyeoraaFontFamily.Pretendard.semiBold, size: 16) ?? .init()
        case .subtitle3:
            return UIFont(font: MoyeoraaFontFamily.Pretendard.regular, size: 18) ?? .init()
        case .body1:
            return UIFont(font: MoyeoraaFontFamily.Pretendard.regular, size: 16) ?? .init()
        case .body2:
            return UIFont(font: MoyeoraaFontFamily.Pretendard.semiBold, size: 14) ?? .init()
        case .body3:
            return UIFont(font: MoyeoraaFontFamily.Pretendard.regular, size: 14) ?? .init()
        case .body4:
            return UIFont(font: MoyeoraaFontFamily.Pretendard.semiBold, size: 12) ?? .init()
        case .caption:
            return UIFont(font: MoyeoraaFontFamily.Pretendard.medium, size: 12) ?? .init()
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .h1, .h2, .body2, .body3:
            return 1.3
        case .subtitle1, .subtitle2, .subtitle3, .body1:
            return 1.4
        case .body4, .caption:
            return 1.2
        }
    }

    var letterSpacing: CGFloat {
        switch self {
        case .h1:
            return -0.05
        case .caption:
            return -0.025
        default:
            return -0.03
        }
    }
}
