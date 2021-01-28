//
//  MovieDetailsLayout.swift
//  Movee
//
//  Created by jjurlits on 11/9/20.
//

import UIKit

class MovieDetailsLayout: UICollectionViewFlowLayout {
    var handler: ((CGFloat) -> ())?
    
    // TODO: clean the mess
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttribures = super.layoutAttributesForElements(in: rect)
        
        guard let collectionView = collectionView else {
            return layoutAttribures
        }
        
        
        
        guard let cellLayoutAttributes = layoutAttribures?.filter({ $0.representedElementCategory == .cell}) else {
            return layoutAttribures
        }

        cellLayoutAttributes.forEach {
            if let newFrame = layoutAttributesForItem(at: $0.indexPath)?.frame {
                $0.frame = newFrame
            }
        }
//
//        guard let headerLayoutAttributes = layoutAttribures?.first(where: {$0.representedElementKind == UICollectionView.elementKindSectionHeader && $0.indexPath.section == 0}) else {
//            return layoutAttribures
//        }
//
//        guard let descriptionCellLayoutAttributes = layoutAttribures?.first(where: { $0.indexPath.section == 0 && $0.indexPath.row == 0}) else {
//            return layoutAttribures
//        }
//
//        headerLayoutAttributes.zIndex = -1
//
//
//
//        let contentOffsetY = collectionView.contentOffset.y
//
////        descriptionCellLayoutAttributes.frame = .init(x: descriptionCellLayoutAttributes.frame.minX, y: -contentOffsetY, width: descriptionCellLayoutAttributes.frame.width, height: descriptionCellLayoutAttributes.frame.height)
//
//        let width = collectionView.frame.width
//        let height = headerLayoutAttributes.frame.height - contentOffsetY
//        //let initialHeight = headerLayoutAttributes.frame.height
//        let minimalHeight = width * 9 / 16
//        headerLayoutAttributes.frame = .init(x: 0, y: contentOffsetY, width: width, height: height)
//
//        //let headerFrameAspectRatio = width / height
//
//        if contentOffsetY > 0 && height < minimalHeight {
//            //let offset =  minimalHeight - height
//            let alpha = height / minimalHeight
//            headerLayoutAttributes.alpha = alpha
//            handler?(1-alpha)
////            let frame = descriptionCellLayoutAttributes.frame
////            descriptionCellLayoutAttributes.frame = .init(
////                x: frame.minX,
////                y: frame.minY - offset,
////                width: frame.width,
////                height: frame.height)
////
//        }
        
        return layoutAttribures
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
         guard let collectionView = collectionView else {
             fatalError()
         }
         guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
             return nil
         }

         layoutAttributes.frame.origin.x = sectionInset.left
         layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
         return layoutAttributes
     }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
}
