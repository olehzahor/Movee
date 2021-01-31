//
//  SearchHistoryController.swift
//  Movee
//
//  Created by jjurlits on 1/24/21.
//

import Foundation

class SearchHistoryController: JSONPersistenceController<Movie>, MoviesListController {
    var title: String { return "Search History" }
    
    func addMovie(_ movie: Movie) {
        guard !items.contains(movie) else { return }
        addItem(movie.short)
    }
    
    func load(fromPage initialPage: Int, infiniteScroll: Bool, completion: @escaping CompletionHandler) {
        DispatchQueue.global().async {
            if !self.isDataLoaded { self.loadData() }
            DispatchQueue.main.async {
                completion(self)
            }
        }
    }
    
    var movies: [Movie] {
        return items.reversed()
    }
    
    func loadMore(completion: CompletionHandler) { }
    func stop() { }

    
    convenience init() {
        self.init(filename: "search_history.json")
    }

}

