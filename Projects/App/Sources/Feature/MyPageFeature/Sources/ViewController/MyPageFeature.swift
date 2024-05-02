//
//  MyPageFeature.swift
//  MyPageFeatureInterface
//
//  Created by 김요한 on 2024/04/01.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

public final class MyPageFeature: BaseFeature {
    private let viewModel: MyPageViewModel
    
    private var dataSource: UITableViewDiffableDataSource<MyPageSection, MyPageCellType>?
    
    private lazy var titleView = MYRNavigationView(title: "마이페이지")
    
    private lazy var profileView = MYRIconView(size: .custom(.init(width: 72, height: 72)), isCircle: true)
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        return stackView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var nameLabel = MYRLabel("", textColor: .neutral(.balck), font: .body1)
    
    private lazy var tagNumberLabel = MYRLabel("", textColor: .neutral(.gray2), font: .body1)
    
    private lazy var editProfileButton = MYRTextButton("회원 설정", textColor: .neutral(.balck), font: .body3, backgroundColor: .primary(.primary2), cornerRadius: 8)
    
    private lazy var myPageTableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.register(MYRNotificationTVC.self)
        view.register(MYRMyPageTVC.self)
        view.separatorStyle = .none
        view.delegate = self
        view.sectionIndexBackgroundColor = .systemBackground
        view.backgroundColor = .systemBackground
        return view
    }()
    
    public init(viewModel: MyPageViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    public override func configureAttributes() {
        self.dataSource = self.generateDataSource()
        self.setNavigationBar(titleView: self.titleView, rightButtonItem: nil)
        self.view.backgroundColor = .white
    }
    
    public override func configureUI() {
        [self.profileView, self.mainStackView,
         self.myPageTableView].forEach {
            self.view.addSubview($0)
        }
        
        [self.nameLabel, self.tagNumberLabel].forEach {
            self.labelsStackView.addArrangedSubview($0)
        }
        
        [self.labelsStackView,
         self.editProfileButton].forEach { self.mainStackView.addArrangedSubview($0)
        }
        
        
        self.profileView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(36)
            make.centerX.equalToSuperview()
        }
        
        self.mainStackView.snp.makeConstraints { make in
            make.top.equalTo(self.profileView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        self.myPageTableView.snp.makeConstraints { make in
            make.top.equalTo(self.mainStackView.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.greaterThanOrEqualTo(self.view.safeAreaLayoutGuide).offset(-50)
        }
        
        self.editProfileButton.snp.makeConstraints { make in
            make.height.equalTo(34)
            make.width.equalTo(67)
        }
    }
    
    public override func bindViewModel() {
        let cellDidSelect = self.myPageTableView.rx.itemSelected.asObservable()
            .withUnretained(self)
            .map { owner, indexPath in
                owner.dataSource?.itemIdentifier(for: indexPath)
            }
        
        let input = MyPageViewModel.Input(
            viewDidAppear: self.rx.viewDidAppear
                .map({ _ in }).asObservable(),
            editButtonDidTap: self.editProfileButton.rx.tap.asObservable(),
            cellDidSelect: cellDidSelect
        )
        
        let output = self.viewModel.trnasform(input: input)
        
        output.userAndDataSource
            .drive(with: self) { owner, val in
                let (user, dataSource) = val
                owner.nameLabel.setText(with: user.name)
                owner.tagNumberLabel.setText(with: "#\(user.tagNumber)")
                owner.profileView.bindImage(urlString: user.profileImage ?? "")
                
                let snapshot = owner.setSnapshot(dataSource: dataSource)
                owner.dataSource?.apply(snapshot)
            }
            .disposed(by: self.disposeBag)
        
        output.alertTrigger.drive(with: self) { owner, cellType in
            switch cellType {
            case .signOut:
                owner.showSignOutAlert()
            case .dropout:
                owner.showDropOutAlert()
            default:
                return
            }
        }
        .disposed(by: self.disposeBag)
    }
}

private extension MyPageFeature {
    private func showSignOutAlert() {
        let alert = MYRAlertController(
            title: "로그아웃",
            message: "정말 로그아웃하시겠습니까?",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let logout = UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            self?.viewModel.signOut()
        }
        
        alert.addActions([cancel, logout])
        
        present(alert, animated: true, completion: nil)
    }
    
    private func showDropOutAlert() {
        let alert = MYRAlertController(
            title: "회원탈퇴",
            message: "정말 탈퇴하시겠습니까?",
            preferredStyle: .alert
        )
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let logout = UIAlertAction(title: "탈퇴하기", style: .destructive) { [weak self] _ in
            self?.viewModel.dropOut()
        }
        
        alert.addActions([cancel, logout])
        
        present(alert, animated: true, completion: nil)
    }
}

extension MyPageFeature: UITableViewDelegate {
    private func generateDataSource() -> UITableViewDiffableDataSource<MyPageSection, MyPageCellType> {
        return UITableViewDiffableDataSource<MyPageSection, MyPageCellType>(tableView: self.myPageTableView) { [weak self] tableView, indexPath, item in
            guard let self else { return UITableViewCell() }
            switch item {
            case var .nofitication(isOn):
                guard let cell = tableView.dequeueCell(MYRNotificationTVC.self, for: indexPath) else { return UITableViewCell() }
                
                cell.bindSwitch(isOn)
                cell.isNotificationDidChange
                    .subscribe {
                        self.viewModel.updateNotification($0)
                    }
                    .disposed(by: self.disposeBag)
                
                return cell
            case .friends:
                guard let cell = tableView.dequeueCell(MYRMyPageTVC.self, for: indexPath) else { return UITableViewCell() }
                cell.setCell(cellType: .leftRightIcon(title: "친구목록", left: .Moyeora.user, right: .Moyeora.chevronRight))
                
                return cell
            case .block:
                guard let cell = tableView.dequeueCell(MYRMyPageTVC.self, for: indexPath) else { return UITableViewCell() }
                cell.setCell(cellType: .leftRightIcon(title: "차단된 유저 목록", left: .Moyeora.userX, right: .Moyeora.chevronRight))
                
                return cell
            case .signOut:
                guard let cell = tableView.dequeueCell(MYRMyPageTVC.self, for: indexPath) else { return UITableViewCell() }
                cell.setCell(cellType: .leftIcon(title: "로그아웃", left: .Moyeora.logOut))
                
                return cell
            case .dropout:
                guard let cell = tableView.dequeueCell(MYRMyPageTVC.self, for: indexPath) else { return UITableViewCell() }
                cell.setCell(cellType: .leftIcon(title: "회원탈퇴", left: .Moyeora.userMinus))
                
                return cell
            case .version:
                guard let cell = tableView.dequeueCell(MYRMyPageTVC.self, for: indexPath) else { return UITableViewCell() }
                cell.setCell(cellType: .labelOnly(title: "앱 버전", content: "1.0.0"))
                
                return cell
            }
        }
    }
    
    private func setSnapshot(dataSource: MyPageDataSource) -> NSDiffableDataSourceSnapshot<MyPageSection, MyPageCellType> {
        var snapshot = NSDiffableDataSourceSnapshot<MyPageSection, MyPageCellType>()
        snapshot.appendSections(MyPageSection.allCases)
        dataSource.forEach { section, cells in
            snapshot.appendItems(cells, toSection: section)
        }
        
        return snapshot
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = MyPageSection.allCases[section].title else { return UIView() }
        let view = MyPageSectionHeader()
        view.setTitle(title)
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 20
        case 1:
            return 40
        default:
            return 20
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
