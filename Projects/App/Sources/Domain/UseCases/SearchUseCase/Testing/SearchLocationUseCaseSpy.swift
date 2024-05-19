//
//  SearchLocationUseCaseSpy.swift
//  SearchUseCaseTesting
//
//  Created by 김요한 on 2024/04/08.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class SearchLocationUseCaseSpy: SearchLocationUseCaseProtocol {
    
    public init() {
        
    }
    
    public func search(keyword: String) -> Observable<[Address]> {
        self.getAddress(keyword: keyword)
    }
    
    private func getAddress(keyword: String) -> Observable<[Address]> {
        let add1 = Address(name: "서면역", address: "진구엿나 어디야", lat: 0.0, lng: 0.0)
        let add2 = Address(name: "대연역", address: "지금여기", lat: 0.0, lng: 0.0)
        let add3 = Address(name: "해운대역", address: "해운대구", lat: 0.0, lng: 0.0)
        
        return Observable.just([add1, add2, add3])
    }
    
}
