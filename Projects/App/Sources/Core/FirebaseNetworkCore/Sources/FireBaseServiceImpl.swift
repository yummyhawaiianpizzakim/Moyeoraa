//
//  FireBaseServiceImpl.swift
//  FirebaseNetworkCoreInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage

public final class FireBaseServiceImpl: FireBaseServiceProtocol {
    static let shared = FireBaseServiceImpl()
    private let database: Firestore
    
    public init(
            firestore: Firestore = Firestore.firestore()
        ) {
            self.database = firestore
        }
    
    public func getDocument(collection: FireStoreCollection, field: String, in values: [Any]) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            var queries = values
            if queries.isEmpty { queries.append("") }
            print("asd \(field) queries \(queries)")
            print(self.database.app.description)
            
            self.database.collection(collection.name)
                .whereField(field, in: queries)
                .getDocuments { snapshot, error in
                    print("snapshot \(snapshot) error \(error)")
                    if let error = error { single(.failure(error)) }
                    
                    guard let snapshot = snapshot else {
                        single(.failure(RxError.unknown))
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    public func getDocument(collection: FireStoreCollection, document: String) -> Single<FirebaseData> {
        return Single<FirebaseData>.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name).document(document).getDocument { snapshot, error in
                if let error = error { single(.failure(error)) }
                
                guard let snapshot = snapshot, let data = snapshot.data() else {
                    single(.failure(RxError.unknown))
                    return
                }
                single(.success(data))
            }
            return Disposables.create()
        }
    }
    
    public func createDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
                .document(document)
                .setData(values) { error in
                    if let error = error { single(.failure(error)) }
                    single(.success(()))
                }
            
            return Disposables.create()
        }
    }
    
    public func updateDocument(collection: FireStoreCollection, document: String, values: FirebaseData) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
                .document(document)
                .updateData(values) { error in
                    if let error = error { single(.failure(error)) }
                    single(.success(()))
                }
            return Disposables.create()
        }
    }
}
