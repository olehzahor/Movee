//
//  EmptyPlaceholder.swift
//  Movee
//
//  Created by jjurlits on 1/29/21.
//

import UIKit

class EmptyPlaceholder: ProgrammaticCollectionViewCell, SelfConfiguringView {
    let label: UILabel = createView {
        $0.backgroundColor = .red
        $0.text = "Empty"
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    override func setupViews() {
        addSubview(label)
        label.fillSuperview()
    }
}
