//
//  DiscoverViewController+Layout.swift
//  Movee
//
//  Created by jjurlits on 4/10/21.
//

import UIKit

extension DiscoverViewController {
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        let padding: CGFloat = 16
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: padding, leading: padding, bottom: padding, trailing: padding)
        section.interGroupSpacing = spacing
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(30.0))

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
