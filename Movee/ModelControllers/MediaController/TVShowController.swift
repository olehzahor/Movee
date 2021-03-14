//
//  TVShowController2.swift
//  Movee
//
//  Created by jjurlits on 2/25/21.
//

import Foundation


class TVShowController: MediaController<TVShow> {
    override var viewModel: MediaViewModel? {
        return media.viewModel
    }

    override var seasons: [Season]? {
        return media.seasons?.filter { ($0.season_number ?? 0) > 0 }
    }

    override var related: [TVShow]? {
        return media.recommendations?.results
    }

    override func loadDetails(completion: @escaping (MediaController<TVShow>) -> Void) {
        guard let tvShowId = media.id else { return }

        let _ = TMDBClient.shared.getTvShowDetails(id: tvShowId) { result in
            switch result {
            case .success(let tvShow):
                self.media = tvShow
                self.isDetailsLoaded = true
            case .failure(let error):
                self.error = error
            }
            completion(self)
        }
    }
}
