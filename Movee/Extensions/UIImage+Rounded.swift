//
//  UIImage+Rounded.swift
//  Movee
//
//  Created by jjurlits on 12/6/20.
//

import UIKit

extension UIImageView {
   func makeRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
        self.clipsToBounds = true
   }
}
