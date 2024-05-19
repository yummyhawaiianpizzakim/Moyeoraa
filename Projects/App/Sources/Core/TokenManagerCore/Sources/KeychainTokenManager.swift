//
//  KeychainTokenManager.swift
//  TokenManagerCoreInterface
//
//  Created by 김요한 on 2024/04/21.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation

public final class KeychainTokenManager: TokenManagerProtocol {
    static let shared = KeychainTokenManager()
    private let securityClass = kSecClassGenericPassword
    
    public init() {
    }
    
    // MARK: - Methods
    public func getToken(with key: KeychainAccount) -> Token? {
        let query: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: key.rawValue,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnAttributes: true,
            kSecReturnData: true
        ]
        
        var item: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &item)
//        print("get status \(status)")
        guard status == errSecSuccess else {
            print(status)
            return nil
        }
        
        guard
            let existingItem = item as? [String: Any],
            let data = existingItem[kSecValueData as String] as? Data,
            let token = String(data: data, encoding: .utf8)
        else {
            return nil
        }
//        print("token  \(token)")
        return token
    }
    
    public func save(token: Token, with key: KeychainAccount) -> Bool {
        guard let tokenData = token.data(using: .utf8) else { return false }
        
        let saveQuery: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: key.rawValue,
            kSecValueData: tokenData
        ]
//        print("tokenData \(tokenData)")
        let status = SecItemAdd(saveQuery as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else if status == errSecDuplicateItem {
//            print("save status \(status)")
            return update(tokenData: tokenData, with: key)
        } else {
//            print("save status \(status)")
            return false
        }
    }
    
    private func update(tokenData: Data, with key: KeychainAccount) -> Bool {
        let updateQuery: [CFString: Any] = [kSecValueData: tokenData]
        let searchQuery: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemUpdate(searchQuery as CFDictionary, updateQuery as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            print(status)
            return false
        }
    }
    
    public func deleteToken(with key: KeychainAccount) -> Bool {
        let searchQuery: [CFString: Any] = [
            kSecClass: securityClass,
            kSecAttrAccount: key.rawValue
        ]
        
        let status = SecItemDelete(searchQuery as CFDictionary)
        
        if status == errSecSuccess {
            return true
        } else {
            print(status)
            return false
        }
    }
    
}
