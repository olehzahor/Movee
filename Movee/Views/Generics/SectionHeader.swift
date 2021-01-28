//
//  SectionTitle.swift
//  Movee
//
//  Created by jjurlits on 11/24/20.
//

import UIKit

class SectionHeader: ProgrammaticCollectionReusableView, SelfConfiguringView {
    private var primaryActionTitle: String = ""
    private var secondaryActionTitle: String?
    
    var action: (() -> ())? {
        didSet {
            actionButton.isHidden = action == nil
        }
    }
    
    @objc func seeAllButtonTouched() {
        action?()
        guard let secondaryActionTitle = secondaryActionTitle else { return }
        let currentTitle = actionButton.title(for: .normal)
        
        if currentTitle == primaryActionTitle {
            actionButton.setTitle(secondaryActionTitle, for: .normal)
        } else if currentTitle == secondaryActionTitle {
            actionButton.setTitle(primaryActionTitle, for: .normal)
        }
    }
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setTitleColor(tintC, for: .normal)
        button.addTarget(self, action: #selector(seeAllButtonTouched), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    override func setupViews() {
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil)
        addSubview(actionButton)
        actionButton.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAction(title: String, secondaryTitle: String? = nil, action: @escaping () -> Void) {
        self.action = action
        primaryActionTitle = title
        secondaryActionTitle = secondaryTitle
        actionButton.setTitle(title, for: .normal)
    }
    
    override func prepareForReuse() {
        action = nil
    }
}

