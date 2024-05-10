//
//  DeleteImageUseCaseImpl.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/9/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import RxSwift

public final class DeleteImageUseCaseImpl: DeleteImageUseCaseProtocol {
    private let imageRepository: ImageRepositoryProtocol
    
    public init(imageRepository: ImageRepositoryProtocol) {
        self.imageRepository = imageRepository
    }
    
    public func delete(imageString: String?) -> Observable<Void> {
        guard let imageString else { return Observable.just(()) }
        
        return self.imageRepository.deleteImage(imageString: imageString)
    }
    
    
}
