//
//  File.swift
//  Movee
//
//  Created by jjurlits on 12/26/20.
//

import Foundation

class RatingFilter: AccumulativeFilter<Int> {
    init() {
        super.init(options: [9, 8, 7, 6, 5])
    }
    
    override func update(filter: inout Filter) {
        if let minimalRating = selectedOptions.max() {
            filter.rating.min = minimalRating
        }
    }
}
