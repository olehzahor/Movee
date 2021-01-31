//
//  LabelCell.swift
//  Movee
//
//  Created by jjurlits on 1/11/21.
//

import UIKit

class LabelCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    let label: UILabel = createView {
        $0.numberOfLines = 0
    }
    
    override func setupViews() {
        addSubview(label)
        label.fillSuperview()
    }
}
