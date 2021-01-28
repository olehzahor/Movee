//
//  SeeAllCell.swift
//  Movee
//
//  Created by jjurlits on 1/11/21.
//

import UIKit

class SeeAllCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    var action: (() -> ())? {
        didSet {
            actionButton.isHidden = action == nil
        }
    }
    
    @objc func seeAllButtonTouched() {
        print("BUTTO")
        action?()
    }
    
    let actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(seeAllButtonTouched), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    func setAction(title: String, action: @escaping () -> Void) {
        self.action = action
        actionButton.setTitle(title, for: .normal)
    }
    
    override func prepareForReuse() {
        //action = nil
    }
    
    override func setupViews() {
        addSubview(actionButton)
        actionButton.fillSuperview()
        
    }
}
