//
//  UpdateLocationUseCaseProtocol.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/4/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol UpdateLocationUseCaseProtocol {
    func update(chatRoomID: String, coordinate: Coordinate, isArrived: Bool) -> Observable<Void> 
}
