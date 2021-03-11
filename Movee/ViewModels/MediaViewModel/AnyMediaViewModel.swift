//
//  AnyMediaViewModel.swift
//  Movee
//
//  Created by jjurlits on 3/2/21.
//

import Foundation

class AnyMediaViewModel<T: Media>: MediaViewModel {
    internal let separator = " ・ "
    internal var media: T
    
    
    var id: Int? { return media.id }
    var title: String { return media.title ?? "" }
    var originalTitle: String { return media.original_title ?? "" }
    
    var allGenres: Genres? { return nil }
    
    var genres: [String] {
        media.genres?.compactMap({ $0.name })
        ?? allGenres?.strings(from: media.genre_ids)
        ?? []
    }
    
    var releaseDate: String {
        return TMDBDateFormatter.shared.localizedDateString(fromDateString: media.release_date)
    }
    
    var year: String {
        return TMDBDateFormatter.shared.year(fromDateString: media.release_date ?? "")
    }
        
    var overview: String? {
        return media.overview
    }
    
    var tagline: String {
        guard let tagline = media.tagline else { return "" }
        return "\(tagline)"
    }
    
    var genresString: InfoString {
        let short = separate(Array(genres.prefix(2)), separator: separator)
        let long = separate(genres, separator: separator)
        
        return InfoString(short: short, long: long)
    }
    
    var rating: Double {
        return media.vote_average ?? 0.0
    }

    var posterURL: URL? {
        guard let posterPath = media.poster_path else { return nil }
        return TMDBClient.shared.fullPosterUrl(path: posterPath)
    }
    
    var backdropURL: URL? {
        guard let backdropPath = media.backdrop_path else { return nil }
        return TMDBClient.shared.fullBackdropUrl(path: backdropPath)
    }
    
    var facts: [[String: String]] {
        var rows = [[String: String]]()
        
        if let countries = media.production_countries, !countries.isEmpty {
            let countryStrings = countries.compactMap { $0.name }
            rows.append(["Country": countryStrings.joined(separator: "\n")])
        }
        
        if let language = media.original_language, !language.isEmpty {
            if let localizedString = Locale.current.localizedString(forLanguageCode: language) {
                rows.append(["Language": localizedString])
            }
        }
        
        if let rating = media.vote_average, let votesCount = media.vote_count, rating > 0, votesCount > 0 {
            rows.append(["Rating": "\(rating) (\(votesCount) votes)"])
        }
        
        return rows
    }
    
    var subtitle: String { return "" }
    var runtime: String { return "" }
    var infoString: InfoString {
        if !year.isEmpty {
            return InfoString(short: year, long: year)
        } else {
            return InfoString(short: "", long: "")
        }
    }

    init(media: T) {
        self.media = media
    }
}
