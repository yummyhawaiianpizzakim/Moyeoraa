//
//  Dictionary+.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/24/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

extension Dictionary<String, Any> {
    
    func toObject<T>() -> T? where T: Decodable {
        guard
            let data = try? JSONSerialization.data(withJSONObject: self),
            let object = try? JSONDecoder().decode(T.self, from: data)
        else {
            return nil
        }
        
        return object
    }
    
    func toObject<T>(_ type: T.Type) -> T? where T: Decodable {
        return self.toObject()
    }
}
