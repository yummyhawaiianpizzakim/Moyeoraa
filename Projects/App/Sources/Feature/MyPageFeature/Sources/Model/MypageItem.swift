//
//  MypageItem.swift
//  MyPageFeature
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation

typealias MyPageDataSource = [MyPageSection: [MyPageCellType]]

enum MyPageSection: Int, CaseIterable, Hashable {
    case setting
    case info
    
    var title: String? {
        switch self {
        case .setting:
            return "설정"
        case .info:
            return "앱 정보"
        }
    }
}

enum MyPageCellType: Hashable {
    case nofitication(_ isOn: Bool)
    case friends
    case block
    case signOut
    case dropout
    case version
}
