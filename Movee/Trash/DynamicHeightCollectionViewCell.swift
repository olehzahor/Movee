////
////  AutoHeightCollectionViewCell.swift
////  Movee
////
////  Created by jjurlits on 11/17/20.
////
//
//import UIKit
//
//class DynamicHeightCollectionViewCell: UICollectionViewCell {
//    func setupViews() { }
//    
//    override func systemLayoutSizeFitting(
//        _ targetSize: CGSize,
//        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
//        verticalFittingPriority: UILayoutPriority) -> CGSize {
//        
//        // Replace the height in the target size to
//        // allow the cell to flexibly compute its height
//        var targetSize = targetSize
//        targetSize.height = CGFloat.greatestFiniteMagnitude
//        
//        // The .required horizontal fitting priority means
//        // the desired cell width (targetSize.width) will be
//        // preserved. However, the vertical fitting priority is
//        // .fittingSizeLevel meaning the cell will find the
//        // height that best fits the content
//        let size = super.systemLayoutSizeFitting(
//            targetSize,
//            withHorizontalFittingPriority: .required,
//            verticalFittingPriority: .fittingSizeLevel
//        )
//        
//        return size
//    }
//    
////    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
////        setNeedsLayout()
////        layoutIfNeeded()
////        let size = systemLayoutSizeFitting(layoutAttributes.size)
////        var frame = layoutAttributes.frame
////        frame.size.height = ceil(size.height)
////        layoutAttributes.frame = frame
////        return layoutAttributes
////    }
//
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
