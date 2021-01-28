//
//  PhotoHeader.swift
//  Movee
//
//  Created by jjurlits on 11/30/20.
//

import UIKit

class BiographyCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    let biographyLabel: UILabel = createView {
        $0.numberOfLines = 0
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    override func setupViews() {
        [biographyLabel].forEach { addSubview($0) }
        biographyLabel.fillSuperview()
    }
}
