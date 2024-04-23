//
//  FireBaseServiceProtocol.swift
//  FirebaseNetworkCoreInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol FireBaseServiceProtocol {
    
    typealias FirebaseData = [String: Any]
    
    func getDocument(collection: FireStoreCollection, field: String, in values: [Any]) -> Single<[FirebaseData]>
    
    func getDocument(collection: FireStoreCollection, document: String) -> Single<FirebaseData>
    
    func createDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void>
    
    func updateDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void> 
}
