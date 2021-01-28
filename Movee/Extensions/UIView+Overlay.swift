//
//  UIView+Overlay.swift
//  Movee
//
//  Created by jjurlits on 12/28/20.
//

import UIKit

extension UIView {
    func addOverlay(color: UIColor = .black, alpha: CGFloat = 0.6) {
        let overlay = UIView()
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = bounds
        overlay.backgroundColor = color
        overlay.alpha = alpha
        addSubview(overlay)
    }
}
