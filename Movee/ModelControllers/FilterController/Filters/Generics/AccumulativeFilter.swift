//
//  File.swift
//  Movee
//
//  Created by jjurlits on 12/26/20.
//

import Foundation

class AccumulativeFilter<ValueType: Comparable & Hashable>: FilterCategory {
    private var _options: [ValueType]
    private(set) var selectedOptions: [ValueType] = []
    
    var options: [MoviesFilterController.Option] {
        _options.compactMap {
            MoviesFilterController.Option(
                name: "\($0)+", value: $0,
                state: state(option: $0),
                picker: pick(option:)
            )
        }
    }
    
    func pick(option: MoviesFilterController.Option) {
        guard let option = option.value as? ValueType else { return }
        
        if selectedOptions.contains(option) {
            selectedOptions.removeAll()
        }
        else {
            let optionsToSelect = _options.filter { $0 <= option }
            selectedOptions.append(contentsOf: optionsToSelect)
        }
    }
    
    func state(option: ValueType) -> MoviesFilterController.Option.State {
        selectedOptions.contains(option) ? .checked : .ignored
    }
    
    func update(filter: inout Filter) { }
    
    func reset() {
        selectedOptions = []
    }
    
    init(options: [ValueType]) {
        _options = options
    }

}
