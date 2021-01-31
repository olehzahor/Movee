//
//  PhotoAndNameCell.swift
//  Movee
//
//  Created by jjurlits on 12/6/20.
//

import UIKit

class PersonPhotoCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    let imageView: UIImageView = createView {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 10.0
    }
    
    let nameLabel: UILabel = createView {
        $0.textAlignment = .center
        $0.font = UIFont.preferredFont(forTextStyle: .title1)
    }
    
    func setPhoto(photoUrl: URL?, placeholder: UIImage? = nil) {
        imageView.sd_setImage(with: photoUrl, placeholderImage: placeholder)
    }
    
    override func setupViews() {
        [imageView].forEach { addSubview($0) }
        imageView.anchor(
            top: topAnchor, leading: nil,
            bottom: bottomAnchor, trailing: nil,
            padding: .init(top: 16, left: 0, bottom: 0, right: 0),
            size: .init(width: 200, height: 300))
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
