//
//  TokenManagerError.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/24/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

enum TokenManagerError: LocalizedError {
    
    case notFound
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Cannot find token in TokenManager."
        }
    }
}
