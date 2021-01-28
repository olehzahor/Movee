//
//  File.swift
//  Movee
//
//  Created by jjurlits on 12/6/20.
//

import UIKit

class ProgrammaticCollectionViewCell: UICollectionViewCell {
    static func createView<T: UIView>(configurator: ((T)->())? = nil) -> T {
        let view = T()
        configurator?(view)
        return view
    }
    
    func setupViews() { }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
