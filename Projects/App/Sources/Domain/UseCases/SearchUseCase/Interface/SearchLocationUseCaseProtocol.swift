//
//  SearchLocationUseCaseProtocol.swift
//  SearchUseCaseTesting
//
//  Created by 김요한 on 2024/04/08.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol SearchLocationUseCaseProtocol: AnyObject {
    func search(keyword: String) -> Observable<[Address]>
}
