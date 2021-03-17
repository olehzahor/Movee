//
//  File.swift
//  Movee
//
//  Created by jjurlits on 12/26/20.
//

import Foundation

class TVShowRuntimeFilter: MovieRuntimeFilter {
    convenience init() {
        let options: [RangeFilter<Int>.Range] = [
            Range(name: "Ultra Short (<5min)", min: 1, max: 5),
            Range(name: "Short (5 to 30min)", min: 5, max: 15),
            Range(name: "Medium (30 to 1hrs)", min: 30, max: 60),
            Range(name: "Long (>1hrs)", min: 60, max: 450)]

        self.init(options: options)
    }
}

class MovieRuntimeFilter: RangeFilter<Int> {
    convenience init() {
        let options = [
            Range(name: "Ultra Short (<1hr)", min: 1, max: 60),
            Range(name: "Short (1 to 1.5hrs)", min: 60, max: 90),
            Range(name: "Medium (1.5 to 2hrs)", min: 90, max: 120),
            Range(name: "Long (>2hrs)", min: 120, max: 450)]
        
        self.init(options: options)
    }
    
    override func update(filter: inout Filter) {
        if let minRuntime = selectionMinValue,
           let maxRuntime = selectionMaxValue {
            filter.runtime = .init(min: minRuntime, max: maxRuntime)
        }
    }
}
