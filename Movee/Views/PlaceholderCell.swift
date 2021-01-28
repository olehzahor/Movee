//
//  PlaceholderCell.swift
//  Movee
//
//  Created by jjurlits on 11/9/20.
//

import UIKit

//TODO: try again button

class PlaceholderCell: UICollectionViewCell, SelfConfiguringView {
    let spinner: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.hidesWhenStopped = true
        return aiv
    }()
   
    override func prepareForReuse() {
        spinner.startAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        
        addSubview(spinner)
        spinner.fillSuperview(padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        spinner.startAnimating()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
