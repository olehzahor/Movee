//
//  ReviewFullView.swift
//  Movee
//
//  Created by jjurlits on 3/15/21.
//

import UIKit

class ReviewScrollView: UIScrollView {
    let contentView = UIView()
    
    
    override func didMoveToSuperview() {
        contentView.anchor(top: topAnchor, leading: superview?.leadingAnchor, bottom: bottomAnchor, trailing: superview?.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    let reviewTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.font = .preferredFont(forTextStyle: .body)
        return textView
    }()
    
    func setupViews() {
        addSubview(contentView)
        contentView.addSubview(reviewTextView)
        reviewTextView.fillSuperview()
        backgroundColor = .systemBackground
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
