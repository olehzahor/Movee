//
//  SelfConfiguringView.swift
//  Movee
//
//  Created by jjurlits on 12/6/20.
//

import Foundation

protocol SelfConfiguringView: class {
    static var reuseIdentifier: String { get }
}

extension SelfConfiguringView {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}
