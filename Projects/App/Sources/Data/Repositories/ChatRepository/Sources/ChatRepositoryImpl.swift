//
//  ChatRepositoryImpl.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class ChatRepositoryImpl: ChatRepositoryProtocol {
    private let firebaseService: FireBaseServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    public init(firebaseService: FireBaseServiceProtocol,
                tokenManager: TokenManagerProtocol) {
        self.firebaseService = firebaseService
        self.tokenManager = tokenManager
    }
    
    public func createChatRoom(plansID: String) -> Observable<String> {
        guard let userID = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        
        let dto = ChatRoomDTO(
            id: UUID().uuidString,
            userID: userID,
            plansID: plansID,
            updatedAt: Date().toStringWithCustomFormat(.timeStamp, locale: .current)
        )
        
        guard let values = dto.asDictionary else {
            return .error(FireStoreError.unknown)
        }
        
        return self.firebaseService.createDocument(
            collection: .chatrooms,
            document: dto.id,
            values: values
        )
        .asObservable()
        .map { dto.id }
    }
    
    func fetchChatRooms(plansIDs: [String]) -> Observable<[ChatRoom]> {
        return self.firebaseService
            .getDocument(collection: .chatrooms, field: "plansID", in: plansIDs)
            .asObservable()
            .map { $0.compactMap { $0.toObject(ChatRoomDTO.self) } }
            .map { $0.map { $0.toEntity() } }
    }
    
    public func observeChatRooms(plansIDs: [String]) -> Observable<[ChatRoom]> {
        self.firebaseService
            .observe(collection: .chatrooms, field: "plansID", in: plansIDs)
            .asObservable()
            .debug("observeChatRooms")
            .map { $0.compactMap { $0.toObject(ChatRoomDTO.self) } }
            .map { $0.map { $0.toEntity() } }
    }
}
