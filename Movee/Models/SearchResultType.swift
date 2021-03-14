//
//  SearchResultType.swift
//  Movee
//
//  Created by jjurlits on 3/12/21.
//

import Foundation

enum SearchResultType: String, CaseIterable {
    case all = "All Results"
    case movies = "Movies"
    case tvs = "TV Shows"
    case people = "People"
    
    static var titles: [String] {
        return self.allCases.compactMap { $0.rawValue }
    }
    
    func listController(query: String) -> AnyMediaListController? {
        switch self {
        case .all:
            return MultiSearchResultsController.multiSearchResult(query: query)
        case .movies:
            return MediaListController<Movie>.moviesSearchResult(query: query)
        case .tvs:
            return MediaListController<TVShow>.tvShowsSearchResult(query: query)
        case .people:
            return MediaListController<Character>.peopleSearchResult(query: query)
        }
    }
}
