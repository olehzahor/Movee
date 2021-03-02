//
//  EpisodeCell.swift
//  Movee
//
//  Created by jjurlits on 2/23/21.
//

import UIKit

class EpisodeCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    let titleLabel: UILabel = createView {
        $0.numberOfLines = 1
        $0.font = UIFont.boldSystemFont(ofSize: 16)
    }
    
    let subtitleLabel: UILabel = createView {
        $0.numberOfLines = 1
        $0.textColor = .secondaryLabel
        $0.font = .preferredFont(forTextStyle: .footnote)
    }
    
    let overviewLabel: UILabel = createView {
        $0.numberOfLines = 0
        $0.font = .preferredFont(forTextStyle: .footnote)
    }
    
    let stillImageView: UIImageView = createView {
        $0.clipsToBounds = true
        $0.sd_imageTransition = .fade
        $0.layer.cornerRadius = 8
        $0.contentMode = .scaleAspectFill
    }
    
    let placeholderLabel: UILabel = createView {
        $0.font = .systemFont(ofSize: 75, weight: .ultraLight)
    }
    
    let ratingView: RatingView = createView {
        $0.ratingLabel.font = .systemFont(ofSize: 8, weight: .semibold)
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    override func setupViews() {
        addSubview(titleLabel)
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel, overviewLabel])
        vStack.alignment = .top
        vStack.axis = .vertical
        vStack.spacing = 4
        
        
        let hStack = UIStackView(arrangedSubviews: [vStack, stillImageView])
        hStack.spacing = 12
        hStack.alignment = .top
        addSubview(hStack)
        
        stillImageView.widthAnchor.constraint(equalToConstant: 110).isActive = true
        stillImageView.heightAnchor.constraint(equalToConstant: 93).isActive = true
        
        stillImageView.addSubview(placeholderLabel)
        placeholderLabel.centerInSuperview()
        
        addSubview(ratingView)
        ratingView.anchor(top: nil, leading: nil, bottom: stillImageView.bottomAnchor, trailing: stillImageView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 3, right: 3))

        
        hStack.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 24, right: 0))
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .systemGray5
        addSubview(separator)
        separator.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
