//
//  ReviewCell.swift
//  Movee
//
//  Created by jjurlits on 3/15/21.
//

import UIKit

class ReviewCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    let reviewLabel: UILabel = createView {
        $0.font = .preferredFont(forTextStyle: .footnote)
        $0.numberOfLines = 10
    }
    override func setupViews() {
        addSubview(reviewLabel)
        reviewLabel.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        backgroundColor = .systemGray5
        layer.cornerRadius = 10
        clipsToBounds = true
        
    }
}
