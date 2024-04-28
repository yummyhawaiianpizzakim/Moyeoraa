//
//  SearchLocationUseCaseImpl.swift
//  SearchUseCaseTesting
//
//  Created by 김요한 on 2024/04/08.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class SearchLocationUseCaseImpl: SearchLocationUseCaseProtocol {
    private let mapRepository: MapRepositoryProtocol
    
    public init(mapRepository: MapRepositoryProtocol) {
        self.mapRepository = mapRepository
    }
    public func search(keyword: String) -> Observable<[Address]> {
        self.mapRepository.searchAddress(keyword)
    }
}
