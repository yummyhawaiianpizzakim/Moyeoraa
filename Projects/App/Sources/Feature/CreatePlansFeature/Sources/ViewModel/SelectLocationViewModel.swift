//
//  SelectLocationViewModel.swift
//  CreatePlansFeatureInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import RxSwift
import RxCocoa

public struct SelectLocationViewModelActions {
    var closeSelectLocationFeature: (_ address: Address) -> Void
}

public final class SelectLocationViewModel: BaseViewModel {
    public var disposeBag = DisposeBag()
    public typealias Action = SelectLocationViewModelActions
    private var actions: Action?
    
    public let selectedAddress = BehaviorRelay<Address?>(value: nil)
    
    private let searchLocationUseCase: SearchLocationUseCaseProtocol
    
    init(searchLocationUseCase: SearchLocationUseCaseProtocol) {
        self.searchLocationUseCase = searchLocationUseCase
    }
    
    public struct Input {
        let searchAddress: Observable<String>
        let doneButtonDidTap: Observable<Void>
    }
    
    public struct Output {
        let addresses: Driver<[Address]>
        let doneButtonIsEnable: Driver<Bool>
    }
    
    public func trnasform(input: Input) -> Output {
        let addresses = input.searchAddress
            .withUnretained(self)
            .flatMap { owner, keyword in
                owner.searchLocationUseCase.search(keyword: keyword)
            }
       
        let isEnabled = self.selectedAddress
//            .debug("isEnabled")
            .withUnretained(self)
            .map { owner, address in
                guard let address else { return false }
                return true
            }
        
        input.doneButtonDidTap
            .withLatestFrom(self.selectedAddress)
            .compactMap({ $0 })
            .subscribe(with: self) { owner, address in
                owner.actions?.closeSelectLocationFeature(address)
            }
            .disposed(by: self.disposeBag)
            
        return Output(addresses: addresses.asDriver(onErrorJustReturn: []), doneButtonIsEnable: isEnabled.asDriver(onErrorJustReturn: false)
        )
    }
    
    public func setAction(_ actions: SelectLocationViewModelActions) {
        self.actions = actions
    }
}
