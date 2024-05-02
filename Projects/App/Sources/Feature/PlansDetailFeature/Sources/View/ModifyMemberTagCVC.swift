//
//  ModifyMemberTagCVC.swift
//  CreatePlansFeatureInterface
//
//  Created by 김요한 on 2024/04/05.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

public final class ModifyMemberTagCVC: UICollectionViewCell {
    public var disposeBag = DisposeBag()
    
    public var userID: String?
    
    public let tagView = MYRTagView(name: "")
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        self.userID = nil
        self.tagView.userLabel.setText(with: "")
        self.tagView.configureXButton()
        self.disposeBag = DisposeBag()
    }
    
    private func configureAttributes() {
        
    }
    
    private func configureUI() {
        self.contentView.addSubview(self.tagView)
        
        self.tagView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}

public extension ModifyMemberTagCVC {
    func bindCell(id: String, name: String, isMyself: Bool) {
        self.userID = id
        self.tagView.userLabel.setText(with: name)
        if isMyself {
            self.tagView.xButton.removeFromSuperview()
        } else {
            self.tagView.configureXButton()
        }
    }
}
