//
//  TitleSubtitleView.swift
//  Movee
//
//  Created by jjurlits on 4/10/21.
//

import UIKit

class TitleSubtitleView: UIView {
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    var subtitle: String? {
        didSet { subtitleLabel.text = subtitle }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label

    }()
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        addSubview(vStack)
        vStack.axis = .vertical
        vStack.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
