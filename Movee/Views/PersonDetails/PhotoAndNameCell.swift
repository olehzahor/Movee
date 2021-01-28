//
//  PhotoAndNameCell.swift
//  Movee
//
//  Created by jjurlits on 12/6/20.
//

import UIKit

//TODO: Move title to section header!
class PhotoAndNameCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    //private var heightConstraint: NSLayoutConstraint!
    
//    func hideImage() {
//        heightConstraint.constant = 0
//    }
//
    let imageView: UIImageView = createView {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10.0
        //$0.isHidden = true
    }
    
    let nameLabel: UILabel = createView {
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    
    func setPhoto(photoUrl: URL?, placeholder: UIImage? = nil) {
        imageView.sd_setImage(with: photoUrl, placeholderImage: placeholder)
        //imageView.isHidden = false
    }
    
    override func setupViews() {
        [imageView].forEach { addSubview($0) }
        imageView.anchor(
            top: topAnchor, leading: nil,
            bottom: bottomAnchor, trailing: nil,
            padding: .init(top: 16, left: 0, bottom: 0, right: 0),
            size: .init(width: 200, height: 300))
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

//        [imageView, nameLabel].forEach { addSubview($0) }
//        nameLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
//        imageView.anchor(top: nameLabel.bottomAnchor, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
//        imageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        heightConstraint = imageView.heightAnchor.constraint(equalToConstant: 300)
//        heightConstraint.isActive = true
//        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
