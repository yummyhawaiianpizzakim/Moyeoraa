//
//  UploadImageUseCaseSpy.swift
//  ImageUseCaseInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class UploadImageUseCaseSpy: UploadImageUseCaseProtocol {
    public init() { }
    public func upload(imageData: Data) -> Observable<String> {
        print("UploadImageUseCaseSpy")
        return Observable.just("")
    }
    
    
}
