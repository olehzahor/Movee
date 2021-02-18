//
//  File.swift
//  Movee
//
//  Created by jjurlits on 2/17/21.
//

import UIKit

class CharacterSearchCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.numberOfLines = 3
        return label
    }()
    
    override func setupViews() {
        addSubview(imageView)
        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 2/3).isActive = true
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        addSubview(vStack)
        vStack.axis = .vertical
        vStack.anchor(top: nil, leading: imageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 0))
        vStack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        vStack.spacing = 4
    }

}

