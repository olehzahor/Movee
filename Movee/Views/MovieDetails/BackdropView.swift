//
//  PosterHeaderView.swift
//  Movee
//
//  Created by jjurlits on 11/9/20.
//

import UIKit

class BackdropView: UICollectionReusableView, SelfConfiguringView {
    private var gradient: CAGradientLayer!
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.sd_imageTransition = .fade
        imageView.clipsToBounds = true
        imageView.alpha = 0.8
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        imageView.fillSuperview()
        gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.locations = [0.5, 1]
        gradient.shouldRasterize = true
        gradient.rasterizationScale = UIScreen.main.scale
        imageView.layer.mask = gradient

        setNeedsLayout()

    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradient.frame = imageView.bounds
        CATransaction.commit()
        imageView.layer.zPosition = -1

    }
}
