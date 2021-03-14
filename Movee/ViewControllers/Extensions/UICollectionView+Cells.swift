//
//  UICollectionView+Cells.swift
//  Movee
//
//  Created by jjurlits on 3/14/21.
//

import UIKit

extension UICollectionView {
    func registerCell<T: SelfConfiguringView>(_ cellClass: T.Type) {
        self.register(
            cellClass,
            forCellWithReuseIdentifier: cellClass.reuseIdentifier
        )
    }

    func dequeueCell<T: SelfConfiguringView>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(
                withReuseIdentifier: cellClass.reuseIdentifier,
                for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue \(cellClass)")
        }
        return cell
    }
    
    func registerHeader<T: SelfConfiguringView>(_ viewClass: T.Type) {
        self.register(
            viewClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: viewClass.reuseIdentifier
        )
    }

    func dequeueHeader<T: SelfConfiguringView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
        guard let header = self.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: viewClass.reuseIdentifier,
                for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue header \(viewClass)")
        }
        return header
    }
    
    func registerFooter<T: SelfConfiguringView>(_ viewClass: T.Type) {
        self.register(
            viewClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: viewClass.reuseIdentifier
        )
    }
    
    func dequeueFooter<T: SelfConfiguringView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
        guard let header = self.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: viewClass.reuseIdentifier,
                for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue footer \(viewClass)")
        }
        return header
    }

}
