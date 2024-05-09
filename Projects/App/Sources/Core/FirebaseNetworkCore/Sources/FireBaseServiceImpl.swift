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

public enum FireStoreError: Error, LocalizedError {
    case unknown
    case decodeError
}

public final class FireBaseServiceImpl: FireBaseServiceProtocol {
    static let shared = FireBaseServiceImpl()
    private let database: Firestore
    private var sharedLocationListener: ListenerRegistration?
    
    public init(
        firestore: Firestore = Firestore.firestore()
    ) {
        self.database = firestore
    }
    
    public func getDocument(collection: FireStoreCollection, document: String) -> Single<FirebaseData> {
        return Single<FirebaseData>.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name).document(document).getDocument { snapshot, error in
                if let error = error { single(.failure(error)) }
                
                guard let snapshot = snapshot, let data = snapshot.data() else {
                    single(.failure(FireStoreError.unknown))
                    return
                }
                single(.success(data))
            }
            return Disposables.create()
        }
    }
    
    public func getDocument(collection: FireStoreCollection, field: String, condition: [String]) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
                .whereField(field, arrayContains: condition)
                .getDocuments { snapshot, error in
                    if let error = error { single(.failure(error)) }
                    
                    guard let snapshot = snapshot else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    public func getDocument(collection: FireStoreCollection, field: String, arrayContainsAny: [String]) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
                .whereField(field, arrayContainsAny: arrayContainsAny)
                .getDocuments { snapshot, error in
                    if let error = error { single(.failure(error)) }
                    
                    guard let snapshot = snapshot else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    public func getDocument(collection: FireStoreCollection, field: String, in values: [Any]) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            var queries = values
            if queries.isEmpty { queries.append("") }
            
            self.database.collection(collection.name)
                .whereField(field, in: queries)
                .getDocuments { snapshot, error in
                    if let error = error { single(.failure(error)) }
                    
                    guard let snapshot = snapshot else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    public func getDocument(collectionPaths: [String], field: String, in values: [Any]) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            var queries = values
            if queries.isEmpty { queries.append("") }
            
            self.database.collection(collectionPaths.joined(separator: "/"))
                .whereField(field, in: queries)
                .getDocuments { snapshot, error in
                    if let error = error { single(.failure(error)) }
                    
                    guard let snapshot = snapshot else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    public func getDocument(collection: FireStoreCollection) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
                .getDocuments { snapshot, error in
                    if let error = error { single(.failure(error)) }
                    
                    guard let snapshot = snapshot else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    public func getDocument(documents: [String]) -> Single<[String: Any]> {
        return Single.create { single in
            self.database.document(documents.joined(separator: "/"))
                .getDocument { snapshot, error in
                    if let error = error { single(.failure(error)) }
                    
                    guard let snapshot = snapshot, let data = snapshot.data() else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    public func getDocument(collection: FireStoreCollection, documents: [String]) -> Single<[FirebaseData]> {
        return Single.create { single in
            let documents = [collection.name] + documents
            self.database
                .collection(documents.joined(separator: "/"))
                .getDocuments { snapshot, error in
                    if let error { single(.failure(error)) }
                    
                    guard let snapshot else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            
            return Disposables.create()
        }
    }
    
    public func getDocument(collection: FireStoreCollection, field: String, keyword value: Any) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            let startValue = "\(value)"
            let endValue = "\(value)\u{f8ff}"
            
            self.database.collection(collection.name)
                .whereField(field, isGreaterThanOrEqualTo: startValue)
                .whereField(field, isLessThanOrEqualTo: endValue)
                .getDocuments { snapshot, error in
                    if let error = error { single(.failure(error)) }
                    
                    guard let snapshot = snapshot else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
                    single(.success(data))
                }
            return Disposables.create()
        }
    }
    
    public func getDocument(collection: FireStoreCollection, field: String, fieldIn: String, keyword value: Any, arrayContainsAny values: [Any]) -> Single<[FirebaseData]> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            let startValue = "\(value)"
            let endValue = "\(value)\u{f8ff}"
            
            var queries = values
            if queries.isEmpty { queries.append("") }
            
            self.database.collection(collection.name)
                .whereField(field, isGreaterThanOrEqualTo: startValue)
                .whereField(field, isLessThanOrEqualTo: endValue)
                .whereField(fieldIn, arrayContainsAny: queries)
                .getDocuments { snapshot, error in
                    if let error = error { single(.failure(error)) }
                    
                    guard let snapshot = snapshot else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
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
    
    public func createDocument(documents: [String], values: FirebaseData) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.document(documents.joined(separator: "/"))
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
    
    public func deleteDocument(collection: FireStoreCollection, document: String) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
                .document(document)
                .delete { error in
                    if let error = error { single(.failure(error)) }
                    single(.success(()))
                }
            return Disposables.create()
        }
    }
    
    public func deleteDocument(documents: [String]) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.document(documents.joined(separator: "/"))
                .delete { error in
                    if let error = error { single(.failure(error)) }
                    single(.success(()))
                }
            return Disposables.create()
        }
    }
    
    public func deleteDocuments(collections: [(FireStoreCollection, String)]) -> Single<Void> {
        let batch = self.database.batch()
        
        collections.forEach { collection, document in
            let document = self.database.collection(collection.name).document(document)
            batch.deleteDocument(document)
        }
        
        return Single.create { single in
            batch.commit { error in
                if let error = error { single(.failure(error)) }
                single(.success(()))
            }
            
            return Disposables.create()
        }
    }
    
    public func deleteDocument(collectionPaths: [String], document: String) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collectionPaths.joined(separator: "/"))
                .document(document)
                .delete { error in
                    if let error = error { single(.failure(error)) }
                    single(.success(()))
                }
            return Disposables.create()
        }
    }
    
}

// MARK: - Observe
public extension FireBaseServiceImpl {
    
    func observer(collection: FireStoreCollection, document: String) -> Observable<FirebaseData> {
        return Observable<FirebaseData>.create { [weak self] observable in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name)
                .document(document)
                .addSnapshotListener { snapshot, error in
                    if let error = error { observable.onError(error) }
                    
                    guard let snapshot = snapshot, let data = snapshot.data() else {
                        observable.onError(FireStoreError.unknown)
                        return
                    }
                    
                    observable.onNext(data)
                }
            return Disposables.create()
        }
    }
    
    func observer(documents: [String]) -> Observable<FirebaseData> {
        return Observable<FirebaseData>.create { [weak self] observable in
            guard let self else { return Disposables.create() }
            
            self.database
                .document(documents.joined(separator: "/"))
                .addSnapshotListener { snapshot, error in
                    if let error = error { observable.onError(error) }
                    
                    guard let snapshot = snapshot, let data = snapshot.data() else {
                        observable.onError(FireStoreError.unknown)
                        return
                    }
                    
                    observable.onNext(data)
                }
            return Disposables.create()
        }
    }
    
    func observe(collection: FireStoreCollection, field: String, in values: [Any]) -> Observable<[FirebaseData]> {
            return Observable.create { [weak self] observable in
                guard let self else { return Disposables.create() }
                
                var queries = values
                if queries.isEmpty { queries.append("") }
                
                self.database
                    .collection(collection.name)
                    .whereField(field, in: queries)
                    .addSnapshotListener { snapshot, error in
                        if let error = error {
                            observable.onError(error)
                        }
                        guard let snapshot = snapshot else {
                            observable.onError(FireStoreError.unknown)
                            return
                        }
                        let data = snapshot.documents.map { $0.data() }
                        
                        observable.onNext(data)
                    }
                return Disposables.create()
            }
    }
    
    func observe(documents: [String]) -> Observable<[FirebaseData]> {
        return Observable.create { [weak self] observable in
            guard let self else { return Disposables.create() }
            self.database
                .collection(documents.joined(separator: "/"))
                .addSnapshotListener { snapshot, error in
                    if let error = error { observable.onError(error) }
                    guard let snapshot = snapshot else {
                        observable.onError(FireStoreError.unknown)
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
                    
                    observable.onNext(data)
                }
            return Disposables.create()
        }
    }
    
}
//MARK: sharedLocation
public extension FireBaseServiceImpl {
    func observeSharedLocation(documents: [String]) -> Observable<[FirebaseData]> {
        return Observable.create { [weak self] observable in
            guard let self else { return Disposables.create() }
            self.sharedLocationListener = self.database
                .collection(documents.joined(separator: "/"))
                .addSnapshotListener { snapshot, error in
                    if let error = error { observable.onError(error) }
                    guard let snapshot = snapshot else {
                        observable.onError(FireStoreError.unknown)
                        return
                    }
                    let data = snapshot.documents.map { $0.data() }
                    
                    observable.onNext(data)
                }
            return Disposables.create()
        }
    }
    
    func removeSharedLocationObserve() -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self 
            else { return Disposables.create() }
            self.sharedLocationListener?.remove()
            single(.success(()))
            return Disposables.create()
        }
    }
}

    //MARK: Image
public extension FireBaseServiceImpl {
    func uploadImage(imageData: Data) -> Single<String> {
        return Single.create { single in
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            let imageName = UUID().uuidString + String(Date().timeIntervalSince1970)
            let firebaseReference = Storage.storage().reference().child("\(imageName)")
            
            firebaseReference.putData(imageData, metadata: metaData) { _, error in
                if let error = error { single(.failure(error)) }
                
                firebaseReference.downloadURL { url, _ in
                    guard let url = url else {
                        single(.failure(FireStoreError.unknown))
                        return
                    }
                    single(.success(url.absoluteString))
                }
            }
            return Disposables.create()
        }
    }
}
