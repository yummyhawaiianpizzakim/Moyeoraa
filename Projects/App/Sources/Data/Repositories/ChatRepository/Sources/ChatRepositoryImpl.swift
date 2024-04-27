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
            .map { $0.compactMap { $0.toObject(ChatRoomDTO.self) } }
            .map { $0.map { $0.toEntity() } }
    }
    
    public func observeChat(chatRoomID: String) -> Observable<[Chat]> {
        guard let userID = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        
        return self.firebaseService
            .observe(documents: ["chatrooms", chatRoomID, "chats"])
            .debug("observeChat(chatRoomID: String)")
            .map { $0.compactMap {
                $0.toObject(ChatDTO.self)?.toEntity(myID: userID) }
            }
            .map { $0.sorted { $0.createdAt < $1.createdAt } }
    }
    
    public func send(content: String, at chatRoomId: String) -> Observable<Void> {
        guard let userId = tokenManager.getToken(with: .userId) else {
            return .error(TokenManagerError.notFound)
        }
        
        let chatDTO = ChatDTO(
            id: UUID().uuidString, 
            chatRoomID: chatRoomId,
            senderUserID: userId,
            senderType: .mine,
            content: content,
            createdAt: Date().toStringWithCustomFormat(.timeStamp),
            isChecked: false
        )
        return self.send(chatRoomId: chatRoomId, chatDTO: chatDTO)
    }
    
    public func updateIsChecked(chatroomId: String, chatId: String, toState state: Bool = true) -> Observable<Void> {
        let values = ["isChecked": state]
        
        return self.firebaseService
            .updateDocument(collection: .chatrooms, document: "\(chatroomId)/chats/\(chatId)", values: values)
            .asObservable()
    }
}

private extension ChatRepositoryImpl {
    func send(chatRoomId: String, chatDTO: ChatDTO) -> Observable<Void> {
            guard let values = chatDTO.asDictionary else {
                return .error(FireStoreError.unknown)
            }
            
            return self.firebaseService
                .createDocument(documents: ["chatrooms", chatRoomId, "chats", chatDTO.id], values: values)
                .asObservable()
                .withUnretained(self)
                .flatMap { owner, _ in owner.updateChatRoomTimestamp(chatroomId: chatRoomId) }
        }
    
    func updateChatRoomTimestamp(chatroomId: String) -> Observable<Void> {
        let timestamp = Date().toStringWithCustomFormat(.timeStamp)
        let values = ["updatedAt": timestamp]
        
        return self.firebaseService
            .updateDocument(collection: .chatrooms, 
                            document: chatroomId,
                            values: values
            )
            .asObservable()
    }
}
