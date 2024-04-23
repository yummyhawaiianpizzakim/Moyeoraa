//
//  UICollectionView+Reusable.swift
//  FoundationUtilities
//
//  Created by 김요한 on 2024/03/22.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit

public extension UICollectionView {
    func register<T>(_ cellClass: T.Type) where T: UICollectionViewCell {
        self.register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func registerReusableView<T>(_ cellClass: T.Type) where T: UICollectionReusableView {
        self.register(
            cellClass.self,
            forSupplementaryViewOfKind: cellClass.reuseIdentifier,
            withReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueCell<T>(_ cellClass: T.Type, for indexPath: IndexPath) -> T? where T: UICollectionReusableView {
        return self.dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T
    }
    
    func dequeResuableView<T>(_ viewClass: T.Type, for indexPath: IndexPath) -> T? where T: UICollectionReusableView {
        return self.dequeueReusableSupplementaryView(ofKind: viewClass.reuseIdentifier, withReuseIdentifier: viewClass.reuseIdentifier, for: indexPath) as? T
    }
}

public extension UICollectionReusableView {
    
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
