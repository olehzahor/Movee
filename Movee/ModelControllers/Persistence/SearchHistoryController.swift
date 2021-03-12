//
//  SearchHistoryController.swift
//  Movee
//
//  Created by jjurlits on 1/24/21.
//

import Foundation

class SearchHistoryController: WatchlistController {
    @objc override var title: String { return "Search History" }
    
    convenience init(completion: @escaping () -> Void) {
        self.init()
        DispatchQueue.global(qos: .background).async {
            self.loadData()
            DispatchQueue.main.async { completion() }
        }
    }
    
    convenience init() {
        self.init(filename: "search_history.json")
    }
    
    override init(filename: String) {
        super.init(filename: filename)
    }
}


//class SearchHistoryController: JSONPersistenceController<Movie>, MoviesListController {
//    var title: String { return "Search History" }
//    
//    func addMovie(_ movie: Movie) {
//        guard !items.contains(where: {$0.id == movie.id}) else { return }
//        addItem(movie.short)
//    }
//    
//    func load(fromPage initialPage: Int, infiniteScroll: Bool, completion: @escaping CompletionHandler) {
//        DispatchQueue.global().async {
//            if !self.isDataLoaded { self.loadData() }
//            DispatchQueue.main.async {
//                completion(self)
//            }
//        }
//    }
//    
//    var movies: [Movie] {
//        return items.reversed()
//    }
//    
//    func loadMore(completion: CompletionHandler) { }
//    func stop() { }
//
//    
//    convenience init() {
//        self.init(filename: "search_history.json")
//        loadData()
//    }
//
//}
//
