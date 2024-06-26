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
    
    func getDocument(collection: FireStoreCollection) -> Single<[FirebaseData]>
    func getDocument(collection: FireStoreCollection, document: String) -> Single<FirebaseData>
    func getDocument(collection: FireStoreCollection, field: String, condition: [String]) -> Single<[FirebaseData]>
    func getDocument(collection: FireStoreCollection, field: String, arrayContainsAny: [String]) -> Single<[FirebaseData]> 
    func getDocument(collection: FireStoreCollection, field: String, in values: [Any]) -> Single<[FirebaseData]>
    func getDocument(collectionPaths: [String], field: String, in values: [Any]) -> Single<[FirebaseData]> 
    func getDocument(documents: [String]) -> Single<FirebaseData>
    func getDocument(collection: FireStoreCollection, documents: [String]) -> Single<[FirebaseData]> 
    func getDocument(collection: FireStoreCollection, field: String, keyword value: Any) -> Single<[FirebaseData]>
    func getDocument(collection: FireStoreCollection, field: String, fieldIn: String, keyword value: Any, arrayContainsAny values: [Any]) -> Single<[FirebaseData]> 
    func createDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void>
    func createDocument(documents: [String], values: FirebaseData) -> Single<Void>
    
    func updateDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void>
    
    func deleteDocument(collection: FireStoreCollection, document: String) -> Single<Void>
    func deleteDocument(collectionPaths: [String], document: String) -> Single<Void> 
    func deleteDocument(documents: [String]) -> Single<Void>
    
    func observer(collection: FireStoreCollection, document: String) -> Observable<FirebaseData>
    func observer(documents: [String]) -> Observable<FirebaseData>
    func observe(collection: FireStoreCollection, field: String, in values: [Any]) -> Observable<[FirebaseData]>
    func observe(documents: [String]) -> Observable<[FirebaseData]>
    
    func observeSharedLocation(documents: [String]) -> Observable<[FirebaseData]> 
    func removeSharedLocationObserve() -> Single<Void> 
    
    func uploadImage(imageData: Data) -> Single<String>
    func deleteImage(path: String) -> Single<Void> 
}
