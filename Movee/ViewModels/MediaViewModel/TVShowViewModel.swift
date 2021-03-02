//
//  TVShowViewModel.swift
//  Movee
//
//  Created by jjurlits on 2/19/21.
//

import Foundation

class TVShowViewModel: AnyMediaViewModel<TVShow> {
    override var originalTitle: String {
        if let originalName = media.original_name, originalName != media.name {
            return originalName
        } else { return "" }
    }
    
    override var runtime: String {
        guard let runtime = media.episode_run_time?.first, runtime > 0 else { return "" }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief
        return formatter.string(from: TimeInterval(runtime * 60)) ?? ""
    }
    
    override var releaseDate: String {
        if let firstAirDate = media.release_date {
            var resultString = "\(TMDBDateFormatter.shared.year(fromDateString: firstAirDate))—"
            if let lastAirDate = media.last_air_date, media.in_production == false {
                resultString += TMDBDateFormatter.shared.year(fromDateString: lastAirDate)
            }
            return "TV Series (\(resultString))"
        } else { return "" }
    }
    
    override var infoString: InfoString {
        let short = separate([year, genresString.short], separator: separator)
        
        var long = separate([releaseDate, runtime], separator: separator)
        if !long.isEmpty, !genresString.long.isEmpty { long += "\n" }
        long += genresString.long
        
        return InfoString(short: short, long: long)
    }
        
    override var facts: [[String : String]] {
        var facts = super.facts
        
        var topFacts: [[String: String]] = []
        
        if let networks = media.networks, !networks.isEmpty {
            let networksStrings = networks.compactMap { $0.name }
            topFacts.append(["Network": networksStrings.joined(separator: separator)])
        }

        if let status = media.status, !status.isEmpty {
            topFacts.append(["Status": status])
        }
        
        if let firstAirDate = media.release_date, !firstAirDate.isEmpty {
            let dateString =
                TMDBDateFormatter.shared.localizedDateString(fromDateString: firstAirDate,
                                                             style: .full)
            topFacts.append(["Premiered": dateString])
        }
        
        if let lastAirDate = media.last_air_date, !lastAirDate.isEmpty {
            let dateString =
                TMDBDateFormatter.shared.localizedDateString(fromDateString: lastAirDate,
                                                             style: .full)
            topFacts.append(["Last Aired": dateString])
        }
        
        if let nextEpisode = media.next_episode_to_air,
           let airDate = nextEpisode.air_date,
           let seasonNumber = nextEpisode.season_number,
           let episodeNumber = nextEpisode.episode_number {
            var nextEpisodeString = "Episode \(episodeNumber) (Season \(seasonNumber))\n"
            nextEpisodeString += "\(TMDBDateFormatter.shared.localizedDateString(fromDateString: airDate, style: .full))"
            topFacts.append(["Next Episode": nextEpisodeString ])
        }
        
        facts = topFacts + facts
    
        return facts
    }
    
    init(tvShow: TVShow) {
        super.init(media: tvShow)
    }
}
