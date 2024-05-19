//
//  ChatRepositoryProtocol.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol ChatRepositoryProtocol: AnyObject {
    func createChatRoom(plansID: String) -> Observable<String>
    func observeChatRooms(plansIDs: [String]) -> Observable<[ChatRoom]>
    func observeChat(chatRoomID: String) -> Observable<[Chat]>
    func send(content: String, at chatRoomId: String) -> Observable<Void>
    func updateIsChecked(chatroomId: String, chatId: String, toState state: Bool) -> Observable<Void>
    func deleteChatRoom(chatroomId: String) -> Observable<Void> 
}
