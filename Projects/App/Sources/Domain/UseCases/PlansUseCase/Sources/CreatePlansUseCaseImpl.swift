//
//  CreatePlansUseCaseImpl.swift
//  PlansUseCaseInterface
//
//  Created by 김요한 on 2024/04/10.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class CreatePlansUseCaseImpl: CreatePlansUseCaseProtocol {
    private let plansRepository: PlansRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let chatRepository: ChatRepositoryProtocol
    
    public init(plansRepository: PlansRepositoryProtocol, 
                userRepository: UserRepositoryProtocol,
                chatRepository: ChatRepositoryProtocol) {
        self.plansRepository = plansRepository
        self.userRepository = userRepository
        self.chatRepository = chatRepository
    }
    
    public func create(title: String, date: Date, location: Address, members: [User]) -> Observable<Void> {
        let plansID = UUID().uuidString
        
        return Observable
            .combineLatest(
                self.userRepository.getUserInfo(),
                self.chatRepository.createChatRoom(plansID: plansID)
            )
            .withUnretained(self)
            .flatMap { owner, val in
                let (user, chatRoomID) = val
                let membersID = members.map { $0.id }
                return self.plansRepository.createPlans(
                    plansID: plansID,
                    makingUser: user,
                    title: title,
                    date: date,
                    location: location,
                    membersID: membersID,
                    chatRoomID: chatRoomID
                )
            }
    }
}
