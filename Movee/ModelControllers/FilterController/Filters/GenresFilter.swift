//
//  File.swift
//  Movee
//
//  Created by jjurlits on 12/26/20.
//

import Foundation



class GenresFilter: FilterCategory {
    private var _options: [Genre]
    private(set) var selectedOptions: [Genre] = []
    private(set) var excludedOptions: [Genre] = []
    
    var options: [MoviesFilterController.Option] {
        _options.compactMap {
            return MoviesFilterController.Option(
                name: $0.name, value: $0,
                state: state(option: $0),
                picker: pick(option:))
        }
    }

    func pick(option: MoviesFilterController.Option) {
        guard let option = option.value as? Genre else { return }
        
        if selectedOptions.contains(option) {
            selectedOptions.removeAll { $0 == option }
            excludedOptions.append(option)
        } else if excludedOptions.contains(option) {
            excludedOptions.removeAll() { $0 == option }
        } else {
            selectedOptions.append(option)
        }
    }
    
    func state(option: Genre) -> MoviesFilterController.Option.State {
        selectedOptions.contains(option) ? .checked
            : (excludedOptions.contains(option) ? .excluded : .ignored)
    }
    
    func update(filter: inout Filter) {
        filter.withGenres = selectedOptions.compactMap { $0.id }
        filter.withoutGenres = excludedOptions.compactMap { $0.id }
    }
    
    func reset() {
        selectedOptions = []
        excludedOptions = []
    }

    
    init(genres: Genres) {
        self._options = genres.genres
    }
}

