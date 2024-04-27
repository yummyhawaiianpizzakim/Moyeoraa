//
//  ObserveChatListUseCaseImpl.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/29.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class ObserveChatListUseCaseImpl: ObserveChatListUseCaseProtocol {
    private let chatRepository: ChatRepositoryProtocol
    private let plansRepository: PlansRepositoryProtocol
    
    public init(chatRepository: ChatRepositoryProtocol,
                plansRepository: PlansRepositoryProtocol) {
        self.chatRepository = chatRepository
        self.plansRepository = plansRepository
    }
    
    public func observe() -> Observable<([ChatRoom], [Plans], [Chat])> {
        let plansArr = self.plansRepository.fetchPlansArr()
        let chatRooms = plansArr.map { $0.map { $0.id } }
            .withUnretained(self)
            .flatMap {
                $0.0.chatRepository.observeChatRooms(plansIDs: $0.1)
            }
        
        let chats = chatRooms
            .withUnretained(self)
//            .debug("chats")
            .flatMap { owner, chatRooms -> Observable<[Chat]> in
                let chatObservables = chatRooms.map { chatRoom -> Observable<Chat?> in
                    owner.chatRepository.observeChat(chatRoomID: chatRoom.id)
                        .compactMap { $0.last }
                        .catchAndReturn(nil)
                }
                return Observable.combineLatest(chatObservables)
                    .map { $0.compactMap { $0 } } // nil 값을 제거하고 Chat 객체만 배열로 반환
            }
  
        return Observable.combineLatest(chatRooms, plansArr, chats)
    }
}
