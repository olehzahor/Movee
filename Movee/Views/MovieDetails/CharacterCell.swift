//
//  CharacterCell.swift
//  Movee
//
//  Created by jjurlits on 11/11/20.
//

import UIKit

class CreditsSectionHeader: UICollectionReusableView, SelfConfiguringView {
    static let reuseIdentifier = "CreditsSectionHeader"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        return label
    }()
    
    func setupViews() {
        addSubview(titleLabel)
        titleLabel.fillSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class CharacterCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    override func layoutSubviews() {
        imageView.makeRounded()
    }
        
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sd_imageTransition = .fade
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "John Smith"
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let subLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
        
    override func setupViews() {
        addSubview(imageView)
        addSubview(label)
        addSubview(subLabel)

        imageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        label.putBelow(view: imageView, spacing: 4)
        subLabel.putBelow(view: label, spacing: 0)
        subLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        imageView.makeRounded()
    }
}
