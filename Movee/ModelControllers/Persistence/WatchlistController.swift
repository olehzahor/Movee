//
//  WatchlistController.swift
//  Movee
//
//  Created by jjurlits on 12/9/20.
//

import Foundation

struct WatchlistItem: Codable, Equatable, Hashable {
    var movie: Movie
    var added: Date
}

class WatchlistController: JSONPersistenceController<WatchlistItem>  {
    static let ncUpdateName = Notification.Name("WatchlistUpdated")
    
    enum SortingKey { case date, title }

    public var sortingKey: SortingKey = .date
    public var sortAscending: Bool = true
        
    override func saveData() {
        super.saveData()
        NotificationCenter.default.post(name: Self.ncUpdateName, object: nil)
    }
    
    func addMovie(_ movie: Movie) {
        guard !items.contains(where: { $0.movie.id == movie.id }) else { return }
        
        let newItem = WatchlistItem(movie: movie.short, added: Date())
        addItem(newItem)
        saveData()
    }
        
    func removeMovie(_ movie: Movie) {
        items.removeAll { $0.movie.id == movie.id }
        saveData()
    }
    
    func contains(_ movie: Movie) -> Bool {
        let movie = items.first { $0.movie.id == movie.id }
        return movie == nil ? false : true
    }
    
    var count: Int {
        return items.count
    }

    func watchlist() -> [WatchlistItem] {
        return items.sorted {
            let first = sortAscending ? $0 : $1
            let second = sortAscending ? $1 : $0
            
            switch sortingKey {
            case .date:
                return first.added > second.added
            case .title:
                return first.movie.title ?? "" > second.movie.title ?? ""
            }
        }
    }
    
    convenience init() {
        self.init(filename: "watchlist.json")
    }
    
    override init(filename: String) {
        super.init(filename: filename)
        loadData()
    }
}

extension WatchlistController: MoviesListController {
    var title: String { return "Watchlist" }

    func load(fromPage initialPage: Int, infiniteScroll: Bool, completion: @escaping CompletionHandler) {
        DispatchQueue.global().async {
            if !self.isDataLoaded { self.loadData() }
            DispatchQueue.main.async {
                completion(self)
            }
        }
    }
    
    var movies: [Movie] {
        return watchlist().compactMap({ $0.movie })
    }
    
    func loadMore(completion: CompletionHandler) { }
    func stop() { }
}

