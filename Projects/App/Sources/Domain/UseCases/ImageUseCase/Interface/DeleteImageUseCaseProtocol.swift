//
//  DeleteImageUseCaseProtocol.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/9/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol DeleteImageUseCaseProtocol {
    func delete(imageString: String?) -> Observable<Void>
}
