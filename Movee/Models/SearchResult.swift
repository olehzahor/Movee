//
//  SearchResult.swift
//  Movee
//
//  Created by jjurlits on 2/17/21.
//

import Foundation

enum SearchResult: Decodable, Hashable {
    init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()
        if let character = try? container?.decode(Character.self) {
            self = .character(character)
        } else if var movie = try? container?.decode(Movie.self) {
            movie.media_type = "movie"
            self = .movie(movie)
        } else if let _ = try? container?.decode(TVShow.self) {
            self = .empty
        } else {
            self = .empty
        }
    }
    
    case movie(Movie)
    case tv(TVShow)
    case character(Character)
    case empty
}

struct PagedSearchResult: Decodable, Hashable {
    var page: Int
    var results: [SearchResult]
    var total_pages: Int
    var total_results: Int
}
