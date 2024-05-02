//
//  UploadImageUseCaseImpl.swift
//  ImageUseCaseInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class UploadImageUseCaseImpl: UploadImageUseCaseProtocol {
    private let imageRepository: ImageRepositoryProtocol
    
    public init(imageRepository: ImageRepositoryProtocol) {
        self.imageRepository = imageRepository
    }
    
    public func upload(imageData: Data) -> Observable<String> {
        self.imageRepository.uploadImage(imageData: imageData)
    }
    
    
}
