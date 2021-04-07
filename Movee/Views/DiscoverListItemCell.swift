//
//  DiscoverListItemCell.swift
//  Movee
//
//  Created by jjurlits on 3/19/21.
//

import UIKit

class DiscoverListItemCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    let _backgroundColor: UIColor = .systemGray5
    let _highlightedBackgroundColor: UIColor = .systemGray6
    
    override var isHighlighted: Bool {
        willSet {
            self.backgroundColor = newValue ? _highlightedBackgroundColor : _backgroundColor
        }
    }
    
    let titleLabel: UILabel = createView {
        $0.font = .preferredFont(forTextStyle: .subheadline)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    override func setupViews() {
        addSubview(titleLabel)
        titleLabel.fillSuperview(padding: .init(top: 8, left: 8, bottom: 8, right: 8))
        backgroundColor = _backgroundColor
        layer.cornerRadius = 10
        clipsToBounds = true
    }
}
