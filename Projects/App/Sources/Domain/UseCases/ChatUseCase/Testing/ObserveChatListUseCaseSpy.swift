//
//  FetchChatUseCaseSpy.swift
//  ChatUseCaseInterface
//
//  Created by 김요한 on 2024/03/29.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class ObserveChatListUseCaseSpy: ObserveChatListUseCaseProtocol {
    
    public init() {
        
    }
    
    public func observe() -> Observable<([ChatRoom], [Plans])> {
        let userID = "1234"
        let chatRooms = self.getChatRoom(userID: userID)
        let plansIDs = chatRooms.map { rooms in
            rooms.map { room in room.plansID }
        }
        
        let plansArr = self.getPlans(chatRoomIDs: plansIDs)
        
        return Observable.combineLatest(chatRooms, plansArr) { chatRooms, plansArr in
               return (chatRooms, plansArr)
           }
    }
    
    public func observe() -> Observable<([ChatRoom], [Plans], [Chat])> {
        return Observable.just(([], [], []))
    }
    
    
    private func getChatRoom(userID: String) -> Observable<[ChatRoom]> {
        if "1234" == userID {
            let chatRoom1 = ChatRoom.stub(id: "qwer", userID: userID, plansID: "asdf")
            let chatRoom2 = ChatRoom.stub(id: "zxcv", userID: userID, plansID: "vbnm")
            let chatRoom3 = ChatRoom.stub(id: "vbnm", userID: userID, plansID: "ghjk")
            return Observable.just([chatRoom1, chatRoom2, chatRoom3])
        }
        return Observable.error(RxError.noElements)
    }
    
    private func getPlans(chatRoomIDs: Observable<[String]>) -> Observable<[Plans]> {
        let plans1 = Plans.stub(id: "aasdf", title: "프로젝트1", date: Date().localizedDate())
        let plans2 = Plans.stub(id: "vbnm", title: "프로젝트2", date: Date().localizedDate())
        let plans3 = Plans.stub(id: "ghjk", title: "프로젝트3", date: Date().localizedDate())
        let plansArr = [plans1, plans2, plans3]
        
        var resultArr = chatRoomIDs.map { ids in
            var resultArr: [Plans] = []
            ids.forEach { id in
                plansArr.forEach { plans in
                    if plans.id == id {
                        resultArr.append(plans)
                    }
                }
            }
            return resultArr
        }
        
        return resultArr
    }
    
}
