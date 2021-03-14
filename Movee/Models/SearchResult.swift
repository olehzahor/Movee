//
//  SearchResult.swift
//  Movee
//
//  Created by jjurlits on 2/17/21.
//

import Foundation


enum SearchResult: MediaListItem {
    static var placeholder: SearchResult {
        return self.empty
    }
    
    var id: Int? {
        switch self {
        case .character(let character):
            return character.id
        case .movie(let movie):
            return movie.id
        case .tv(let tvShow):
            return tvShow.id
        default:
            return nil
        }
    }
    
    private struct TypedResult: Decodable {
        enum MediaType: String, Decodable {
            case unknown
            case movie = "movie"
            case tvShow = "tv"
            case character = "person"
        }
        var media_type: MediaType
    }
    
    init(from decoder: Decoder) throws {
        let container = try? decoder.singleValueContainer()
        
        if let result = try? container?.decode(TypedResult.self) {
            switch result.media_type {
            case .movie:
                if let movie = try? container?.decode(Movie.self) {
                    self = .movie(movie)
                } else { self = .empty }
            case .tvShow:
                if let tvShow = try? container?.decode(TVShow.self) {
                    self = .tv(tvShow)
                } else { self = .empty }
            case .character:
                if let character = try? container?.decode(Character.self) {
                    self = .character(character)
                } else { self = .empty }
            default:
                self = .empty
            }
        } else { self = .empty }
    }
    
    func encode(to encoder: Encoder) throws {
        
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
