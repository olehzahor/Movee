//
//  RangeFilter.swift
//  Movee
//
//  Created by jjurlits on 12/26/20.
//

import Foundation

class RangeFilter<ValueType: Comparable & Hashable>: FilterCategory {
    struct Range: Hashable {
        var name: String
        var min: ValueType
        var max: ValueType
    }

    private var _options: [Range]
    private(set) var selectedOptions: [Range] = []

    var options: [MoviesFilterController.Option] {
        _options.compactMap {
            MoviesFilterController.Option(
                name: $0.name,
                value: $0,
                state: state(option: $0),
                picker: pick(option:))
        }
    }
    
    private var boundaries: ClosedRange<Int>? {
        let selectedIndicies = selectedOptions.compactMap {
            _options.firstIndex(of: $0)
        }
        guard let lowerBoundaryIndex = selectedIndicies.min(),
              let upperBoundaryIndex = selectedIndicies.max()
        else { return nil }
        
        return lowerBoundaryIndex ... upperBoundaryIndex
    }
    
    private func isNeighbour(_ option: Range) -> Bool {
        guard let optionIndex = _options.firstIndex(of: option),
              let boundaries = boundaries
        else { return false }
                
        return [boundaries.lowerBound - 1, boundaries.upperBound + 1].contains(optionIndex)
    }
    
    
    private func isExtreme(_ option: Range) -> Bool {
        guard let optionIndex = _options.firstIndex(of: option),
              let boundaries = boundaries
        else { return false }
        return [boundaries.lowerBound, boundaries.upperBound].contains(optionIndex)
    }
    
    internal var selectionMinValue: ValueType? {
        selectedOptions
            .compactMap({$0.min})
            .min()
    }
    
    internal var selectionMaxValue: ValueType? {
        selectedOptions
            .compactMap({$0.max})
            .max()
    }
    
    func pick(option: MoviesFilterController.Option) {
        guard let option = option.value as? Range
        else { return }
        
        if selectedOptions.contains(option) {
            if isExtreme(option) {
                selectedOptions.removeAll() { $0 == option }
            } else {
                selectedOptions.removeAll()
            }
        } else {
            if !selectedOptions.isEmpty {
                if isNeighbour(option) {
                    selectedOptions.append(option)
                } else {
                    selectedOptions = [option]
                }
            } else {
                selectedOptions.append(option)
            }
        }
    }
    
    func state(option: Range) -> MoviesFilterController.Option.State {
        selectedOptions.contains(option) ? .checked : .ignored
    }
    
    func update(filter: inout Filter) { }
    
    func reset() {
        selectedOptions = []
    }
    
    init(options: [Range]) {
        self._options = options
    }
}

