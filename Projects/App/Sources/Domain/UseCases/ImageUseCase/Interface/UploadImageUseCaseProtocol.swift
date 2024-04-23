//
//  UploadImageUseCaseProtocol.swift
//  ImageUseCaseInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public protocol UploadImageUseCaseProtocol: AnyObject {
    func upload(imageData: Data) -> Observable<String>
}
