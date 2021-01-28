//
//  File.swift
//  Movee
//
//  Created by jjurlits on 12/26/20.
//

import Foundation

class RuntimeFilter: RangeFilter<Int> {
    init() {
        let options = [
            Range(name: "Ultra Short (<1hr)", min: 0, max: 60),
            Range(name: "Short (1 to 1.5hrs)", min: 60, max: 90),
            Range(name: "Medium (1.5 to 2hrs)", min: 90, max: 120),
            Range(name: "Long (>2hrs)", min: 120, max: 450)]
        super.init(options: options)
    }
    
    override func update(filter: inout Filter) {
        if let minRuntime = selectionMinValue,
           let maxRuntime = selectionMaxValue {
            filter.runtime = .init(min: minRuntime, max: maxRuntime)
        }
        
//        if let minRuntime = selectedOptions.compactMap({($0 as? Range<Int>)?.min}).min(),
//           let maxRuntime = selectedOptions.compactMap({($0 as? Range<Int>)?.max}).max() {
//            filter.runtime = .init(min: minRuntime, max: maxRuntime)
//        }
    }
}
