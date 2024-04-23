//
//  Encodable+.swift
//  FoundationUtilities
//
//  Created by 김요한 on 2024/04/21.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

public extension Encodable {
    
    var asDictionary: [String: Any]? {
        guard
            let object = try? JSONEncoder().encode(self),
            let dictinoary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String: Any]
        else {
            return nil
        }
        
        return dictinoary
    }
}
