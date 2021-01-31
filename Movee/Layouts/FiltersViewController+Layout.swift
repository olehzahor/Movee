//
//  FiltersViewController+Layout.swift
//  Movee
//
//  Created by jjurlits on 12/24/20.
//

import UIKit

extension FiltersViewController {
    func createPickerSection() -> NSCollectionLayoutSection {
        let estimatedHeight: CGFloat = 50
        let estimatedWidth: CGFloat = 20
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(estimatedWidth),
                                              heightDimension: .estimated(estimatedHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.edgeSpacing = .init(leading: nil, top: .fixed(4), trailing: .fixed(8), bottom: .fixed(4))
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(estimatedHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        group.edgeSpacing = .init(leading: nil, top: nil, trailing: nil, bottom: .fixed(2))
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.contentInsets = .init(top: 8, leading: 16, bottom: 16, trailing: 16)
                
        return section
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            return self.createPickerSection()
        }
    }
}
