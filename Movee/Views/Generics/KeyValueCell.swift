//
//  KeyValueCell.swift
//  Movee
//
//  Created by jjurlits on 12/6/20.
//

import UIKit

class KeyValueCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    let keyLabel: UILabel = createView() {
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
    }
    let valueLabel: UILabel = createView() {
        $0.font = UIFont.preferredFont(forTextStyle: .callout)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 0
        $0.textAlignment = .right
        //$0.backgroundColor = .red
    }
    let separator: UIView = createView {
        $0.backgroundColor = .systemGray4
    }
    
    override func setupViews() {
        [keyLabel, valueLabel, separator].forEach { addSubview($0) }
        keyLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 8, left: 0, bottom: 8, right: 0))
        valueLabel.anchor(top: topAnchor, leading: keyLabel.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 8, right: 0))
        keyLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        valueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        separator.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
