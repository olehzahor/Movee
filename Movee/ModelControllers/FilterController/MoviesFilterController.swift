//
//  Filter2.swift
//  Movee
//
//  Created by jjurlits on 12/25/20.
//

import Foundation

class MoviesFilterController {
    internal var genresFilter: GenresFilter?
    internal var ratingFilter = RatingFilter()
    internal var votesFilter = VotesFilter()
    internal var runtimesFilter = MovieRuntimeFilter()
    internal var datesFilter = ReleaseDateFilter()
    
    lazy var categories: [Section: FilterCategory?] = {
        [.genres: genresFilter,
         .dates: datesFilter,
         .rating: ratingFilter,
         .runtime: runtimesFilter,
         .votes: votesFilter]
    }()
    
    var shortGenres = true
    var updateHandler: ((MoviesFilterController) -> Void)?
    
    var filter: Filter {
        var filter = Filter()
        categories.forEach { $0.value?.update(filter: &filter) }
        return filter
    }
    
    func options(forSection section: Section) -> [MoviesFilterController.Option] {
        if section == .genres {
            if let genreOptions = genresFilter?.options {
                return shortGenres ? Array(genreOptions[..<9]) : genreOptions
            } else { return [] }
        } else {
            return categories[section]??.options ?? []
        }
    }
    
    func reset() {
        categories.forEach { $0.value?.reset() }
    }
    
    internal func createGenresFilter() {
        if let genres = TMDBClient.shared.genres.movie {
            self.genresFilter = GenresFilter(genres: genres)
        } else {
            TMDBClient.shared.loadMovieGenres { genres in
                guard let genres = genres else { return }
                self.genresFilter = GenresFilter(genres: genres)
                self.updateHandler?(self)
            }
        }
    }
    
    init() {
        createGenresFilter()
    }
}

extension MoviesFilterController {
    enum Section: String, CaseIterable {
        case genres = "Genres"
        case rating = "Rating"
        case votes = "Votes Count"
        case runtime = "Runtime"
        case dates = "Release Date"
        
        var title: String {
            return self.rawValue
        }
    }
    
    struct Option: Hashable, Equatable {
        enum State {
            case included, excluded, ignored, checked
        }

        var name: String
        var value: AnyHashable
        var state: State
        var picker: (MoviesFilterController.Option) -> Void
        
        func pick() {
            picker(self)
        }
        
        static func == (lhs: MoviesFilterController.Option, rhs: MoviesFilterController.Option) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
            hasher.combine(value)
            hasher.combine(state)
        }
    }

}
