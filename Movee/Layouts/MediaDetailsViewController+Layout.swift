//
//  DetailsLayout.swift
//  Movee
//
//  Created by jjurlits on 11/25/20.
//

import UIKit
class StrechyHeaderCompositionalLayout: UICollectionViewCompositionalLayout {
    var originalHeaderHeight: CGFloat = 0
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            let layoutAttributes = super.layoutAttributesForElements(in: rect)

            layoutAttributes?.forEach { attribute in
                if attribute.representedElementKind == UICollectionView.elementKindSectionHeader,
                   attribute.indexPath.section == 0 {
                    guard let collectionView = collectionView else { return }
                    let contentOffsetY = collectionView.contentOffset.y

                    if contentOffsetY == 0 {
                        originalHeaderHeight = attribute.frame.height
                    }

                    attribute.zIndex = -1

                    if contentOffsetY < 0 {
                        let width = collectionView.frame.width
                        let height = originalHeaderHeight - contentOffsetY
                        attribute.frame = CGRect(x: 0, y: contentOffsetY, width: width, height: height)
                    }

                    if contentOffsetY > 0 {
                        let alpha = contentOffsetY / originalHeaderHeight / 3
                        attribute.alpha = 1 - alpha
                    }
                }
            }
            return layoutAttributes
        }

        override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
            return true
        }
}

extension MediaDetailsViewController {
    func createLayout() -> UICollectionViewLayout {
        return StrechyHeaderCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = self.findSection(at: sectionIndex, in: self.dataSource)
            else { fatalError("Couldn't find section at index: \(sectionIndex)") }
            
            switch section {
            case .description:
                return self.createDescriptionSection()
            case .credits:
                return self.createCreditsSection()
            case .related, .seasons:
                return GenericLayouts.createHorizontalListSection(height: 188, width: 110, addHeader: true)
            case .trailer:
                return GenericLayouts.createFullWidthSection(addHeader: false)
            case .info:
                return GenericLayouts.createFullWidthSection(addHeader: true)
            }
            
        }
    }
    
    
    func createCreditsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //item.contentInsets.leading = 8
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(100),
            heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets.trailing = 5
        group.contentInsets.leading = 5
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(30.0))
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.boundarySupplementaryItems = [header]

        return section
    }
    
    func createRelatedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(108),
            heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets.trailing = 8
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(108),
            heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //group.contentInsets.leading = 8
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(30.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    func createDescriptionSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300))
        let movieItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: movieItem, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(300))
        
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)

        if self.mediaController.isBackdropAvaiable {
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            header.contentInsets = .init(top: -16, leading: -16, bottom: -16, trailing: -16)
            
            section.boundarySupplementaryItems = [header]
        }

        
        return section
    }
}
