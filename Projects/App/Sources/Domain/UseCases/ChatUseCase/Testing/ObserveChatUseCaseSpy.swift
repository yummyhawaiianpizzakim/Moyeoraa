//
//  ObserveChatUseCaseSpy.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/30.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class ObserveChatUseCaseSpy: ObserveChatUseCaseProtocol {
    public init() {
        
    }
    
    public func observe(chatRoomID: String) -> Observable<[Chat]> {
        return self.getChats(chatRoomID: chatRoomID)
//            .debug("observe")
            .withUnretained(self)
            .flatMap { owner, chats -> Observable<[Chat]> in
                let userIDs = chats.map { $0.senderUserID }.removingDuplicates()
                return owner.getUser(userIDs: userIDs)
                    .map { users in
                        owner.mapChatWithUser(chats: chats, users: users)
                    }
            }
    }
    
    func getChats(chatRoomID: String) -> Observable<[Chat]> {
        let id = "1234"
        let chat1 = Chat(id: "qwer", senderUserID: "asdf", senderType: .mine, content: "테스트 테스트", createdAt: Date().addingTimeInterval(100), isChecked: true)
        let chat2 = Chat(id: "asdf", senderUserID: "zxcv", senderType: .other, content: "테스트 테스트22", createdAt: Date().addingTimeInterval(200), isChecked: true)
        let chat3 = Chat(id: "dfgh", senderUserID: "zxcv", senderType: .other, content: "테스트 테스트33", createdAt: Date().addingTimeInterval(300), isChecked: true)
        var resultArr: [Chat] = []
        if id == chatRoomID {
            resultArr.append(chat1)
            resultArr.append(chat2)
            resultArr.append(chat3)
        }
        return Observable.just(resultArr)
    }
    
    func getUser(userIDs: [String]) -> Observable<[User]> {
        let user1 = User(id: "asdf", name: "alalal", tagNumber: 3456, profileImage: nil, fcmToken: "bmvn", isNotification: false)
        let user2 = User(id: "zxcv", name: "gjgjgjgj", tagNumber: 1928, profileImage: nil, fcmToken: "rutj", isNotification: false)
        let user3 = User(id: "cfth", name: "fjensj", tagNumber: 2110, profileImage: nil, fcmToken: "xociv", isNotification: false)
        var userArr = [user1, user2, user3]
        
        var resultArr: [User] = []
        
        userIDs.forEach { id in
            userArr.forEach { user in
                if id == user.id {
                    resultArr.append(user)
                }
            }
        }
        
        return Observable.just(resultArr)
    }
    
    func mapChatWithUser(chats: [Chat], users: [User]) -> [Chat] {
        var mapedChats: [Chat] = []
        
        chats.forEach { chat in
            users.forEach { user in
                if chat.senderUserID == user.id {
                    var mutableChat = chat
                    mutableChat.user = user
                    mapedChats.append(mutableChat)
                }
            }
        }
        
        return mapedChats
    }
}
