////
////  CastCell.swift
////  Movee
////
////  Created by jjurlits on 11/11/20.
////
//
//import UIKit
//
//class CreditsCell: DynamicHeightCollectionViewCell {
//    var height: CGFloat = 0
//    var isLayoutCompleted: Bool = false
//    var heightConstraint: NSLayoutConstraint?
//
//    var horizontalController: UICollectionViewController? {
//        didSet {
//            setupHorizontalController()
//        }
//    }
//
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Cast & Crew"
//        label.font = .systemFont(ofSize: 16, weight: .medium)
//        return label
//    }()
//
//    func updateHeight(_ height: CGFloat) {
//        let collectionViewHeight = horizontalController?.collectionView.contentSize.height ?? 0
//        print("*****\(collectionViewHeight)")
//        let newHeight = max(self.height, collectionViewHeight)
//        if newHeight > self.height {
//            print("******newheight:\(newHeight)")
//            heightConstraint?.constant = newHeight
//            self.height = newHeight
//            setNeedsLayout()
//            layoutIfNeeded()
//        }
//    }
//
//    override func setupViews() {
//        addSubview(titleLabel)
//        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 16))
//    }
//
//    func setupHorizontalController() {
//        guard let horizontalController = horizontalController else { return }
//        addSubview(horizontalController.view)
//        horizontalController.view.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
//
//        heightConstraint = horizontalController.view.heightAnchor.constraint(equalToConstant: 50)
//        heightConstraint?.isActive = true
//
//    }
//}
//
