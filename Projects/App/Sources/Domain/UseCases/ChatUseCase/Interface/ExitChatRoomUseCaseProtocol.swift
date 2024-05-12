//
//  ExitChatRoomUseCaseProtocol.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/12/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol ExitChatRoomUseCaseProtocol {
    func exit(plansID: String) -> Observable<Void>
}
