//
//  File.swift
//  Movee
//
//  Created by jjurlits on 12/26/20.
//

import Foundation

class VotesFilter: AccumulativeFilter<Int> {
    init() {
        super.init(options: [100, 500, 2000, 5000, 7000, 10000])
    }
    
    override func update(filter: inout Filter) {
        if let minimalVotesCount = selectedOptions.max() {
            filter.votes.min = minimalVotesCount
        }
    }
}
