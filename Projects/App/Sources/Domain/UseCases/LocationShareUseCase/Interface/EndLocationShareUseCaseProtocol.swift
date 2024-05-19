//
//  EndLocationShareUseCaseProtocol.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/6/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol EndLocationShareUseCaseProtocol {
    func complete(chatRoomID: String) -> Observable<Void>
}
