//
//  MYRTimeCVC.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/22.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import SnapKit

public final class MYRTimeCell: UICollectionViewCell {
    private lazy var timeLabel = MYRLabel("00:00", textColor: .neutral(.balck), font: .body3)
    
    public override var isSelected: Bool {
        didSet {
            self.updateSelectionAttributes(isSelected)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureAttributes()
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MYRTimeCell {
    func configureUI() {
        self.contentView.addSubview(timeLabel)
        self.timeLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureAttributes() {
        self.contentView.backgroundColor = .moyeora(.neutral(.gray5))
        self.contentView.layer.cornerRadius = MYRConstants.cornerRadiusSmall
    }
    
    private func updateSelectionAttributes(_ isSelected: Bool) {
        if isSelected {
            self.contentView.backgroundColor = .moyeora(.primary(.primary2))
            self.timeLabel.textColor = .moyeora(.neutral(.white))
            self.timeLabel.font = .moyeora(.body2)
        } else {
            self.contentView.backgroundColor = .moyeora(.neutral(.gray5))
            self.timeLabel.textColor = .moyeora(.neutral(.balck))
            self.timeLabel.font = .moyeora(.body3)
        }
    }
}

public extension MYRTimeCell {
    
    func bindCell(with date: Date) {
        self.timeLabel.text = date.toStringWithCustomFormat("HH:mm")
    }
}
