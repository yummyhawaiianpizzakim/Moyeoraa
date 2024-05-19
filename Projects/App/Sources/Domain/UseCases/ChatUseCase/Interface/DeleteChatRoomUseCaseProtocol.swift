//
//  DeleteChatRoomUseCaseProtocol.swift
//  Moyeoraa
//
//  Created by 김요한 on 4/30/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol DeleteChatRoomUseCaseProtocol: AnyObject {
    func delete(chatRoomID: String) -> Observable<Void>
}
