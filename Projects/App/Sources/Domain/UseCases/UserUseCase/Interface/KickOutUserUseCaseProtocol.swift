//
//  KickOutUserUseCaseProtocol.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/2/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol KickOutUserUseCaseProtocol {
    func kickOut(plansID: String, usersID: [String]) -> Observable<Void> 
}
