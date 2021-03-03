//
//  ReminderCell.swift
//  Movee
//
//  Created by jjurlits on 3/3/21.
//

import UIKit

class ReminderCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    let label: UILabel = createView {
        $0.text = "New episode in 3 days! [Remind]"
        $0.font = .preferredFont(forTextStyle: .callout)
    }
    
    override func setupViews() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 5
        clipsToBounds = true
        addSubview(label)
        label.fillSuperview(padding: .init(top: 0, left: 8, bottom: 0, right: 8))
    }
}
