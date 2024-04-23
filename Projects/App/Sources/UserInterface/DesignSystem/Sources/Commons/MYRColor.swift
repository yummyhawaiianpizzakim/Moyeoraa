//
//  Color+.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/18.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

protocol MYRColorable {
    var color: UIColor { get }
}

public extension UIColor {
    enum MYRColorSystem {
        case primary(Primary)
        case neutral(Neutral)
        case system(System)
    }

    static func moyeora(_ style: MYRColorSystem) -> UIColor {
        switch style {
        case let .primary(colorable as MYRColorable),
            let .neutral(colorable as MYRColorable),
            let .system(colorable as MYRColorable):
            
            return colorable.color
        }
    }
}

public extension UIColor.MYRColorSystem {
    enum Primary: MYRColorable {
        case primary1
        case primary2
    }
    
    enum Neutral: MYRColorable {
        case balck
        case gray1
        case gray2
        case gray3
        case gray4
        case gray5
        case white
    }
    
    enum System: MYRColorable {
        case error
        case success
    }
}

public extension UIColor.MYRColorSystem.Primary {
    var color: UIColor {
        switch self {
        case .primary1: return MoyeoraaAsset.Primary.primay1.color
        case .primary2: return MoyeoraaAsset.Primary.primay2.color
        }
    }
}

public extension UIColor.MYRColorSystem.Neutral {
    var color: UIColor {
        switch self {
        case .gray1: return MoyeoraaAsset.Neutral.gray1.color
        case .gray2: return MoyeoraaAsset.Neutral.gray2.color
        case .gray3: return MoyeoraaAsset.Neutral.gray3.color
        case .gray4: return MoyeoraaAsset.Neutral.gray3.color
        case .gray5: return MoyeoraaAsset.Neutral.gray5.color
        case .balck: return MoyeoraaAsset.Neutral.black.color
        case .white: return MoyeoraaAsset.Neutral.white.color
        }
    }
}

public extension UIColor.MYRColorSystem.System {
    var color: UIColor {
        switch self {
        case .error: return MoyeoraaAsset.System.error.color
        case .success: return MoyeoraaAsset.System.success.color
        }
    }
}
