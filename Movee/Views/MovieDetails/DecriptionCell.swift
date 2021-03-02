//
//  DecriptionCell.swift
//  Movee
//
//  Created by jjurlits on 11/9/20.
//

import UIKit

class DescriptionCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    private var titleTopConstraint: NSLayoutConstraint?
    private var posterTopConstraint: NSLayoutConstraint?
    
    let defaultSpacing: CGFloat = 8.0
    
    func setupWithoutOverlap() {
        titleTopConstraint?.isActive = false
        posterTopConstraint?.isActive = true
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 25, weight: .ultraLight)
        label.textAlignment = .center
        return label
    }()
    
    let originalTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.textAlignment = .center
        return label
    }()
    
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    let poster: PosterView = {
        let posterView = PosterView()
        posterView.layer.cornerRadius = 5
        posterView.clipsToBounds = true
        return posterView
    }()
    
    let taglineLabel: UILabel = createView {
        $0.font = .italicSystemFont(ofSize: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .left
    }
        
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()

    override func setupViews() {
        [poster, titleLabel, originalTitleLabel,
         infoLabel, taglineLabel, overviewLabel].forEach({addSubview($0)})

        titleLabel.anchor(top: nil,
                          leading: poster.trailingAnchor,
                          bottom: nil, trailing: trailingAnchor,
                          padding: .init(top: 0, left: defaultSpacing, bottom: 0, right: 0))
        
        titleTopConstraint = titleLabel.topAnchor.constraint(equalTo: topAnchor)
        titleTopConstraint?.isActive = true

        originalTitleLabel.putBelow(view: titleLabel, spacing: 0)
        infoLabel.putBelow(view: originalTitleLabel, spacing: defaultSpacing)
        

        poster.anchor(top: nil, leading: leadingAnchor, bottom: infoLabel.bottomAnchor, trailing: nil, size: .init(width: 100, height: 150))
        posterTopConstraint = poster.topAnchor.constraint(equalTo: topAnchor)
        
        taglineLabel.anchor(top: infoLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: defaultSpacing, left: 0, bottom: 0, right: 0))
        
        overviewLabel.putBelow(view: taglineLabel, spacing: 2)
        overviewLabel.attachToBottom()
//        overviewLabel.anchor(top: infoLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: defaultSpacing, left: 0, bottom: 0, right: 0))
    }
}
