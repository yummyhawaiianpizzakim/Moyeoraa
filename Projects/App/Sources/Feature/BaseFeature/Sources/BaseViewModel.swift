//
//  BaseViewModel.swift
//  BaseFeature
//
//  Created by 김요한 on 2024/03/27.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift

public protocol BaseViewModel: AnyObject {
    var disposeBag: DisposeBag { get }
    
    associatedtype Action
    
    associatedtype Input
    
    associatedtype Output
    
    func trnasform(input: Input) -> Output
    
    func setAction(_ actions: Action) 
}
