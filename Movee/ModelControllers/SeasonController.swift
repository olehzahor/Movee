//
//  SeasonController.swift
//  Movee
//
//  Created by jjurlits on 2/24/21.
//

import Foundation

class SeasonController {
    private var tvShowId: Int?
    private var season: Season?
    
    var title: String? {
        return season?.name
    }
    
    var episodes: [Episode] {
        return season?.episodes ?? []
    }
    
    func load(completion: @escaping () -> Void) {
        guard let seasonNumber = season?.season_number, let tvShowId = tvShowId else {
            return
        }
        
        TMDBClient.shared.getSeasonDetails(tvShowId: tvShowId, seasonNumber: seasonNumber) { result in
            switch result {
            case .success(let season):
                self.season = season
                completion()
            default:
                return
            }
        }
    }
    
    init(tvShowId: Int?, season: Season?) {
        self.tvShowId = tvShowId
        self.season = season
    }
}
