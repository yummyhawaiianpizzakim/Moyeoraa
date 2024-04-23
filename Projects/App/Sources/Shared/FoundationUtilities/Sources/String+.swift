//
//  String+.swift
//  FoundationUtilities
//
//  Created by 김요한 on 2024/04/15.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import CryptoKit

public extension String {
    
    func toSha256() -> String {
        let data = Data(self.utf8)
        let hashedData = SHA256.hash(data: data)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
            
        return hashString
    }
    
    static var errorDetected: String {
        return "오류가 발생했습니다.\n잠시 후 다시 시도해주세요."
    }
}
