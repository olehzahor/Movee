//
//  MovieListCell.swift
//  Movee
//
//  Created by jjurlits on 12/6/20.
//

import UIKit

class MovieListCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    static var reuseIdentifier: String = "MovieListCell"
    
    let yearLabel: UILabel = createView() {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    let infoLabel: UILabel = createView() {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.numberOfLines = 0
    }
    let separator: UIView = createView {
        $0.backgroundColor = .systemGray4
    }
    
    override func setupViews() {
        [yearLabel, infoLabel, separator].forEach { addSubview($0) }
        
        yearLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 8, right: 0))
        yearLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        infoLabel.anchor(top: topAnchor, leading: yearLabel.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 16, bottom: 8, right: 8))
        infoLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        separator.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
