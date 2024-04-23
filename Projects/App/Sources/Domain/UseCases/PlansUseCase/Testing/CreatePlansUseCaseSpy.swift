//
//  CreatePlansUseCaseSpy.swift
//  PlansUseCaseInterface
//
//  Created by 김요한 on 2024/04/10.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class CreatePlansUseCaseSpy: CreatePlansUseCaseProtocol {
    public init() {
        
    }
    
    public func create(title: String, date: Date, location: Address, members: [User]) -> Observable<Void> {
        let userID = "1234"
        let usersID = members.map { $0.id }
        let chatRoomID = UUID().uuidString
        
        let plans = Plans(id: UUID().uuidString, title: title, date: date, location: location.name, latitude: location.lat, longitude: location.lng, imageURLString: nil, makingUserID: userID, usersID: usersID, chatRoomID: chatRoomID, status: .active)
        print(plans)
        return Observable.just(())
//        return Observable.error(RxError.unknown)
    }
    
}
