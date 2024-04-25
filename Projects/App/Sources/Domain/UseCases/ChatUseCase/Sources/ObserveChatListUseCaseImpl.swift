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
    
    public func observe() -> Observable<([ChatRoom], [Plans])> {
        let plansArr = self.plansRepository.fetchPlansArr()
        let chatRooms = plansArr.map { $0.map { $0.id } }
            .withUnretained(self)
            .flatMap {
                $0.0.chatRepository.observeChatRooms(plansIDs: $0.1)
            }
        
        return Observable.combineLatest(plansArr, chatRooms)
            .withUnretained(self)
            .map({ owner, val in
                let (plansArr, chatRooms) = val
                return owner.mapPlansAndChatRoom(chatRooms: chatRooms, plansArr: plansArr)
            })
    }
    
    private func mapPlansAndChatRoom(chatRooms: [ChatRoom], plansArr: [Plans]) -> (([ChatRoom], [Plans])) {
        var resultTuple: ([ChatRoom], [Plans]) = ([], [])
        
        plansArr.forEach { plans in
            chatRooms.forEach { chatRoom in
                if plans.id == chatRoom.plansID {
                    resultTuple.0.append(chatRoom)
                    resultTuple.1.append(plans)
                }
            }
        }
        return resultTuple
    }
}
