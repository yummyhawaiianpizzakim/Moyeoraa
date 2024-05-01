//
//  BlockRepositoryImpl.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class BlockRepositoryImpl: BlockRepositoryProtocol {
    
    private let firebaseService: FireBaseServiceProtocol
    private let tokenManager: TokenManagerProtocol
    
    public init(firebaseService: FireBaseServiceProtocol,
                tokenManager: TokenManagerProtocol) {
        self.firebaseService = firebaseService
        self.tokenManager = tokenManager
    }
    
    public func createBlockUser(userID: String) -> Observable<Void> {
        guard let myID = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        
        let dto = BlockDTO(
            blockId: UUID().uuidString,
            blockedUserId: userID,
            userId: myID
        )
        
        guard let values = dto.asDictionary else { return .error(LocalError.structToDictionaryError) }
        
        return self.firebaseService
            .createDocument(collection: .blocks, document: dto.blockId, values: values)
            .asObservable()
    }
    
    public func fetchBlocks() -> Observable<[Block]> {
        guard let userID = self.tokenManager.getToken(with: .userId)
        else { return .error(TokenManagerError.notFound) }
        
        return self.firebaseService
            .getDocument(collection: .blocks, field: "userId", in: [userID])
            .map { $0.compactMap { $0.toObject(BlockDTO.self)?.toEntity() }
            }
            .asObservable()
    }
}
