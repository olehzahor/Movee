//
//  TVShowsFilterController.swift
//  Movee
//
//  Created by jjurlits on 3/17/21.
//

import Foundation

class TVShowsFilterController: MoviesFilterController {
    override func createGenresFilter() {
        if let genres = TMDBClient.shared.genres.tv {
            self.genresFilter = GenresFilter(genres: genres)
        } else {
            TMDBClient.shared.loadTVGenres { genres in
                guard let genres = genres else { return }
                self.genresFilter = GenresFilter(genres: genres)
                self.updateHandler?(self)
            }
        }
    }
    override init() {
        super.init()
        self.runtimesFilter = TVShowRuntimeFilter()
        self.datesFilter = TVShowReleaseDateFilter()
    }
}
