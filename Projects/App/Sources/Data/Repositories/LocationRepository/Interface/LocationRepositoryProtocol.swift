//
//  LocationRepositoryProtocol.swift
//  AuthRepositoryInterface
//
//  Created by 김요한 on 2024/04/16.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol LocationRepositoryProtocol: AnyObject {
    func updateLocation(chatRoomID: String, coordinate: Coordinate) -> Observable<Void>
    func observe(chatRoomID: String) -> Observable<[SharedLocation]> 
    func removeObserve() -> Observable<Void> 
    func completeShare(chatroomId: String) -> Observable<Void>
}
