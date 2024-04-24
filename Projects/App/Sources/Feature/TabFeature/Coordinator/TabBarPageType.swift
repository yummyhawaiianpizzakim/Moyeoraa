//
//  TabBarPageType.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/24/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import UIKit

enum TabBarPageType: Int, CaseIterable {
    case home = 0, chat, myPage
    
    // MARK: - Properties
    var tabBarItem: UITabBarItem {
        switch self {
        case .home:
            return UITabBarItem(
                title: "일정",
                image: .Moyeora.calendar,
                tag: self.rawValue
            )
        case .chat:
            return UITabBarItem(
                title: "채팅",
                image: .Moyeora.messageSquare,
                tag: self.rawValue
            )
        case .myPage:
            return UITabBarItem(
                title: "마이페이지",
                image: .Moyeora.user,
                tag: self.rawValue
            )
        }
    }
}
