//
//  SelectLocationFeature.swift
//  CreatePlansFeatureInterface
//
//  Created by 김요한 on 2024/04/04.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

public final class SelectLocationFeature: BaseFeature {
    public let viewModel: SelectLocationViewModel
    
    var lastSelectedIndexPath: IndexPath?
    
    public var dataSource: UITableViewDiffableDataSource<Int, Address>?
    
    private lazy var searchView = MYRSearchView()
    
    private lazy var locationTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.register(LocationTVC.self)
        view.separatorStyle = .none
        view.allowsSelection = true
        view.delegate = self
        return view
    }()
    
    private lazy var emptyView = MYREmptyView()
    
    private lazy var doneButton = MYRTextButton("선택 완료", textColor: .neutral(.balck), font: .subtitle1, backgroundColor: .primary(.primary2), cornerRadius: 16)
    
    public init(viewModel: SelectLocationViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func configureAttributes() {
        self.setNavigationBar(isBackButton: true, titleView: self.searchView, rightButtonItem: nil)
        self.dataSource = self.generateDataSource()
        self.view.backgroundColor = .white
        self.emptyView.type = .searchLocation
        self.emptyView.isHidden = true
    }
    
    public override func configureUI() {
        [self.locationTableView, self.emptyView, self.doneButton]
            .forEach { self.view.addSubview($0) }
        
        self.locationTableView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.doneButton.snp.top).offset(12)
        }
        
        self.emptyView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(self.doneButton.snp.top).offset(12)
        }
        
        self.doneButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-24)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(50)
        }
    }
    
    public override func bindViewModel() {
        let searchAddress = self.searchView.iconTextField.rx.text.orEmpty
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asObservable()
        
        let input = SelectLocationViewModel.Input(
            searchAddress: searchAddress,
            doneButtonDidTap: self.doneButton.rx.tap.asObservable()
        )
        
        let output = self.viewModel.trnasform(input: input)
        
        output.addresses
            .drive(with: self) { owner, addresses in
                owner.emptyView.bindEmptyView(isEmpty: addresses.isEmpty)
                
                let snapshot = owner.setSnapshot(addresses: addresses)
                owner.dataSource?.apply(snapshot)
            }
            .disposed(by: self.disposeBag)
        
        output.doneButtonIsEnable.drive(with: self) { owner, isEnable in
            owner.doneButton.isEnabled = isEnable
        }
        .disposed(by: self.disposeBag)
    }
    
}


extension SelectLocationFeature: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
   
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let address = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        
        if let lastIndexPath = lastSelectedIndexPath,
            lastIndexPath == indexPath {
            self.viewModel.selectedAddress.accept(nil)
            tableView.deselectRow(at: indexPath, animated: true)
            lastSelectedIndexPath = nil
        } else {
            lastSelectedIndexPath = indexPath
            self.viewModel.selectedAddress.accept(address)
            
        }
    }

    private func generateDataSource() -> UITableViewDiffableDataSource<Int, Address> {
        let dataSource = UITableViewDiffableDataSource<Int, Address>(tableView: self.locationTableView) { [weak self] tableView, indexPath, item in
            guard let self, let cell = tableView.dequeueCell(LocationTVC.self, for: indexPath)
            else { return UITableViewCell() }
            cell.bindCell(address: item.name, fullAdd: item
                .address)
            
            return cell
        }
        return dataSource
    }
    
    private func setSnapshot(addresses: [Address]) -> NSDiffableDataSourceSnapshot<Int, Address> {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Address>()
        snapshot.appendSections([0])
        snapshot.appendItems(addresses)
        return snapshot
    }
}
