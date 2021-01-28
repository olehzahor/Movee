//
//  File.swift
//  Movee
//
//  Created by jjurlits on 12/26/20.
//

import Foundation

class ReleaseDateFilter: RangeFilter<Date> {
    override func update(filter: inout Filter) {
        
        if let minDate = selectionMinValue,
           let maxDate = selectionMaxValue {
            filter.primaryReleaseDate = minDate ... maxDate
        }
    }

    init() {
        super.init(options: Self.dates)
    }
}

private extension ReleaseDateFilter {
    static var dates: [Range] = {
        var dates: [Range] = []
        let currentYear = Calendar.current.component(.year, from: Date())
        for i in 0...2 {
            let year = currentYear - i
            if let range = createDateRangeForYear(year) {
                dates.append(Range(name: "\(year)",
                                   min: range.lowerBound,
                                   max: range.upperBound))
            }
        }
        
        for decade in stride(from: 2020, to: 1920, by: -10) {
            if let range = createDateRangeForYears(
                from: decade, to: decade + 9) {
                dates.append(Range(name: "\(decade)s",
                                   min: range.lowerBound,
                                   max: range.upperBound))
            }
        }
        return dates
    }()
    
    static func createDateRangeForYears(from minYear: Int, to maxYear: Int) -> ClosedRange<Date>? {
        var minDateComponents = DateComponents()
        minDateComponents.year = minYear
        minDateComponents.month = 1
        minDateComponents.day = 1
        
        var maxDateComponents = DateComponents()
        maxDateComponents.year = maxYear
        maxDateComponents.month = 12
        maxDateComponents.day = 31
        
        let minDate = Calendar(identifier: .gregorian).date(from: minDateComponents)
        let maxDate = Calendar(identifier: .gregorian).date(from: maxDateComponents)
        
        if let minDate = minDate, let maxDate = maxDate {
            return minDate...maxDate
        } else { return nil }
    }
    
    static func createDateRangeForYear(_ year: Int) -> ClosedRange<Date>? {
        createDateRangeForYears(from: year, to: year)
    }
}
