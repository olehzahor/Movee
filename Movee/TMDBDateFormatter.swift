//
//  TMDBDateFormatter.swift
//  Movee
//
//  Created by jjurlits on 2/24/21.
//

import Foundation

class TMDBDateFormatter {
    static var shared: TMDBDateFormatter { return TMDBDateFormatter() }
    lazy var dateFormatter = DateFormatter()
    
    func date(fromString dateString: String) -> Date? {
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
    
    func localizedDateString(fromDateString dateString: String?, style: DateFormatter.Style! = .medium) -> String {
        guard let dateString = dateString, let date = date(fromString: dateString) else { return "" }
        dateFormatter.dateStyle = style
        return dateFormatter.string(from: date)
    }
    
    func year(fromDateString dateString: String) -> String {
        if let date = date(fromString: dateString) {
            let calendar = Calendar.current
            return "\(calendar.component(.year, from: date))"
        } else {
            return ""
        }
    }
    
    private init() { }
}
