//
//  SearchResult.swift
//  Movee
//
//  Created by jjurlits on 2/17/21.
//

import Foundation



enum SearchResult: Decodable, Hashable {
    private struct Media: Codable {
        var media_type: String?
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()
        if let character = try? container?.decode(Character.self) {
            self = .character(character)
        } else if let media = try? container?.decode(Media.self) {
            switch media.media_type {
            case "movie":
                if let movie = try? container?.decode(Movie.self) {
                    self = .movie(movie)
                }
                else {
                    self = .empty
                }
            case "tv":
                if let tvShow = try? container?.decode(TVShow.self) {
                    self = .tv(tvShow)
                }
                else {
                    self = .empty
                }

            default:
                self = .empty
            }
        } else {
            self = .empty
        }
        
//
//        else if var movie = try? container?.decode(Movie.self) {
//            movie.media_type = "movie"
//            self = .movie(movie)
//        } else if var tvShow = try? container?.decode(TVShow.self) {
//            tvShow.media_type = "tv"
//            self = .tv(tvShow)
//        } else {
//            self = .empty
//        }
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
