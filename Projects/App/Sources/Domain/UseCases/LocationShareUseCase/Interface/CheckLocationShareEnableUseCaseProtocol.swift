//
//  CheckLocationShareEnableUseCaseProtocol.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/15/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol CheckLocationShareEnableUseCaseProtocol: AnyObject {
    func check(plansID: String) -> Observable<Bool> 
}
