//
//  Numeric+Dollars.swift
//  Movee
//
//  Created by jjurlits on 12/28/20.
//

import Foundation

extension NSNumber {
    var dollars: String {
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = .init(identifier: "en_US")
        return currencyFormatter.string(from: self) ?? ""
    }
}
