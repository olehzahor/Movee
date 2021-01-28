//
//  Date+Tommorow.swift
//  Movee
//
//  Created by jjurlits on 12/25/20.
//

import Foundation

extension Date {
    var tommorow: Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }
    
    var yesterday: Date? {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)
    }
}
