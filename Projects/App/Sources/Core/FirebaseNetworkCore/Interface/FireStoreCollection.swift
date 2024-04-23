//
//  FireStoreCollection.swift
//  FirebaseNetworkCoreInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

public enum FireStoreCollection: String {
    case blocks, chatrooms, plans, users, chats
    
    public var name: String {
        return self.rawValue
    }
}
