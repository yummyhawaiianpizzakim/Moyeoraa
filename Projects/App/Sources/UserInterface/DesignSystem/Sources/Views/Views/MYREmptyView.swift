//
//  MYREmptyView.swift
//  Moyeoraa
//
//  Created by 김요한 on 5/12/24.
//  Copyright © 2024 com.moyeora. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

public final class MYREmptyView: UIView {
    
    public var type: ViewType = .home {
        didSet { self.setTitle() }
    }

    private lazy var titleLabel = MYRLabel("", textColor: .neutral(.balck), font: .body1)
    
    public init() {
        super.init(frame: .zero)
        
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setTitle() {
        self.titleLabel.setText(with: type.title)
    }
    
    func configureAttributes() {
        self.backgroundColor = .white
        self.setTitle()
    }
    
    func configureUI() {
        [self.titleLabel].forEach {
            self.addSubview($0)
        }
        
        self.titleLabel.snp.makeConstraints { make in
//            make.top.centerX.equalToSuperview()
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Type
public extension MYREmptyView {
    
    enum ViewType: Int, CaseIterable {
        case home = 0
        case searchLocation
        case searchUser
        case friend
        case chatList
        case block
        
        var title: String {
            switch self {
            case .home:
                return "해당 날짜에 약속이 없습니다."
            case .searchLocation:
                return "검색된 장소결과가 없습니다."
            case .searchUser:
                return "검색된 사용자가 없습니다."
            case .friend:
                return "검색되거나 등록된 친구가 없습니다."
            case .chatList:
                return "아직 활성화된 채팅방이 없습니다."
            case .block:
                return "검색되거나 등록된 차단 사용자가 없습니다."
            }
        }
    }
    
    func bindEmptyView(isEmpty: Bool) {
        if !isEmpty {
            self.isHidden = true
        } else {
            self.isHidden = false
        }
    }
}
