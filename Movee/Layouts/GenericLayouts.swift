//
//  GenericLayouts.swift
//  Movee
//
//  Created by jjurlits on 12/1/20.
//

import UIKit

class GenericLayouts {
    static func createFullWidthSection(height: CGFloat? = nil, addHeader: Bool = false) -> NSCollectionLayoutSection? {
        
        let itemHeight: NSCollectionLayoutDimension
        let groupHeight: NSCollectionLayoutDimension
        
        if let height = height {
            itemHeight = .fractionalHeight(1.0)
            groupHeight = .absolute(height)
        } else {
            itemHeight = .estimated(20)
            groupHeight = .estimated(20)
        }
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
        
        if addHeader {
            section.boundarySupplementaryItems = [GenericLayouts.createSectionHeader()]
        }
        return section
    }
    
    static func createHorizontalListSection(height: CGFloat? = nil, width: CGFloat? = nil, addHeader: Bool = false) -> NSCollectionLayoutSection {
        
        let itemHeight: NSCollectionLayoutDimension
        let groupHeight: NSCollectionLayoutDimension
        
        let itemWidth: NSCollectionLayoutDimension
        let groupWidth: NSCollectionLayoutDimension

        
        if let height = height {
            itemHeight = .absolute(height)
            groupHeight = .absolute(height)
        } else {
            itemHeight = .estimated(20)
            groupHeight = .estimated(20)
        }
        
        if let width = width {
            itemWidth = .absolute(width)
            groupWidth = .absolute(width)
        } else {
            itemWidth = .estimated(20)
            groupWidth = .estimated(20)
        }
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: itemWidth,
            heightDimension: itemHeight)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 8
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: groupWidth,
            heightDimension: groupHeight)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)

        if addHeader {
            section.boundarySupplementaryItems = [GenericLayouts.createSectionHeader()]
        }
        
        return section
    }
    
    static func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(30.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        return header
    }
}
