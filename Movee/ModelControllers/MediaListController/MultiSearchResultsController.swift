//
//  MultiSearchResultsController.swift
//  Movee
//
//  Created by jjurlits on 3/12/21.
//

import Foundation

extension SearchResult {
    var mediaContainer: AnyHashable? {
        switch self {
        case .character(let character):
            return character
        case .tv(let tvShow):
            return tvShow
        case .movie(let movie):
            return movie
        case .empty:
            return SearchResult.placeholder
        }
    }
}

class MultiSearchResultsController: MediaListController<SearchResult> {
    override var medias: [AnyHashable] {
        guard let medias = super.medias as? [SearchResult] else { return [] }
        return medias.compactMap { $0.mediaContainer }
    }
    
    static func multiSearchResult(query: String) -> Self {
        return .init { (page, completion) -> URLSessionTask? in
            TMDBClient.shared.searchMulti(query: query, page: page, completion: completion)
        }
    }
}
