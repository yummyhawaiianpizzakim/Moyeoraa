//
//  DeleteChatRoomUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/30/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class DeleteChatRoomUseCaseImpl: DeleteChatRoomUseCaseProtocol {
    private let chatRepository: ChatRepositoryProtocol
    
    public init(chatRepository: ChatRepositoryProtocol) {
        self.chatRepository = chatRepository
    }
    
    public func delete(chatRoomID: String) -> Observable<Void> {
        self.chatRepository.deleteChatRoom(chatroomId: chatRoomID)
    }
    
}
