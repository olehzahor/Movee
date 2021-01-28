//
//  CompactMovieCell.swift
//  Movee
//
//  Created by jjurlits on 12/2/20.
//

import UIKit

class CompactMovieCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    static let reuseIdentifier = "CompactMovieCell"
    let defaultSpacing: CGFloat = 8
    
    let poster: PosterView = createView {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let titleLabel: UILabel = createView {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        $0.numberOfLines = 2
        //$0.backgroundColor = .red
    }
    
    let subtitleLabel: UILabel = createView {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.numberOfLines = 2
        $0.textColor = .secondaryLabel
    }

    
    override func setupViews() {
        addSubview(titleLabel)
        [poster, titleLabel, subtitleLabel].forEach { addSubview($0) }
        poster.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 100, height: 150))
        titleLabel.putBelow(view: poster, spacing: 4)
        subtitleLabel.putBelow(view: titleLabel, spacing: 0)
        //subtitleLabel.attachToBottom()
        
//        poster.anchor(top: topAnchor,
//                               leading: nil,
//                               bottom: nil,
//                               trailing: nil, size: .init(width: 100, height: 150))
//        poster.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
//        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
//        poster.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)


//        poster.setContentHuggingPriority(.defaultLow, for: .vertical)
//        poster.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
//        titleLabel.putBelow(view: poster, spacing: defaultSpacing)
//        subtitleLabel.putBelow(view: titleLabel, spacing: 0)
//        subtitleLabel.attachToBottom()
    }
}
