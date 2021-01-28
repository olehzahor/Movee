//
//  HintFooter.swift
//  Movee
//
//  Created by jjurlits on 12/14/20.
//

import UIKit

class HintFooter: ProgrammaticCollectionReusableView, SelfConfiguringView {
    let label: UILabel = createView {
        $0.font = UIFont.preferredFont(forTextStyle: .footnote)
        $0.textColor = UIColor.secondaryLabel
        $0.numberOfLines = 0
    }
    
    override func setupViews() {
        addSubview(label)
        label.fillSuperview()
    }
}
