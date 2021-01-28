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
    var watched: Bool! = false
}

class WatchlistController: JSONPersistenceController<WatchlistItem>  {
    static let ncUpdateName = Notification.Name("WatchlistUpdated")
    
    enum SortingKey { case date, title }

    public var sortingKey: SortingKey = .date
    public var sortAscending: Bool = true
    
    private var isDataLoaded: Bool = false
    
    override func saveData() {
        super.saveData()
        NotificationCenter.default.post(name: Self.ncUpdateName, object: nil)
    }
    
    func addMovie(_ movie: Movie) {
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
        return items.filter({!$0.watched}).sorted {
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
    
    var history: [WatchlistItem] {
        return items.filter({$0.watched}).reversed()
    }
    
    private func getItemIndex(forMovie movie: Movie) -> Int? {
        guard let item = items.first(where: { $0.movie.id == movie.id}),
              let index = items.firstIndex(of: item)
        else { return nil }
        return index
    }
    
    func markWatched(movie: Movie) {
        if let index = getItemIndex(forMovie: movie) {
            items[index].watched = true
            saveData()
        }
    }
    
    func markNotWatched(movie: Movie) {
        if let index = getItemIndex(forMovie: movie) {
            items[index].watched = false
            saveData()
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
        return watchlist().compactMap { $0.movie }
    }
    
    func loadMore(completion: CompletionHandler) { }
    func stop() { }
}


//class WatchlistController2 {
//    var shouldUpdate = true
//    //var delegate: WatchlistControllerDelegate?
//
//    private var _watchlist = [WatchlistItem]()
//    private var isDataLoaded: Bool = false
//    lazy private var encoder = JSONEncoder()
//    lazy private var decoder = JSONDecoder()
//    private var filename: String
//    static let ncUpdateName = Notification.Name("WatchlistUpdated")
//
//    public var sortingKey: SortingKey = .date
//    public var sortAscending: Bool = true
//
//    private func loadData() {
//        if let savedWatchlist = Data.load(fromFile: filename) {
//            if let loadedWatchlist = try? decoder.decode([WatchlistItem].self, from: savedWatchlist) {
//                self._watchlist = loadedWatchlist
//                self.isDataLoaded = true
//            }
//        }
//    }
//
//    private func saveData() {
//        if let encoded = try? encoder.encode(_watchlist) {
//            encoded.save(toFile: filename)
//            NotificationCenter.default.post(name: Self.ncUpdateName, object: nil)
//        }
//    }
//
//    func addMovie(_ movie: Movie) {
//        let newItem = WatchlistItem(movie: movie.short, added: Date())
//        _watchlist.append(newItem)
//        saveData()
//    }
//
//    func removeItem(_ item: WatchlistItem) {
//        _watchlist.removeAll { $0 == item }
//        saveData()
//    }
//
//    func removeMovie(_ movie: Movie) {
//        _watchlist.removeAll { $0.movie.id == movie.id }
//        saveData()
//    }
//
//    func contains(_ movie: Movie) -> Bool {
//        let movie = _watchlist.first { $0.movie.id == movie.id }
//        return movie == nil ? false : true
//    }
//
//    var count: Int {
//        return _watchlist.count
//    }
//
//
//    func watchlist() -> [WatchlistItem] {
//        shouldUpdate = false
//        return _watchlist.sorted {
//            let first = sortAscending ? $0 : $1
//            let second = sortAscending ? $1 : $0
//
//            switch sortingKey {
//            case .date:
//                return first.added > second.added
//            case .title:
//                return first.movie.title ?? "" > second.movie.title ?? ""
//            }
//        }
//    }
//
//    init(filename: String = "watchlist.json") {
//        print("watchlist controller initialized")
//        self.filename = filename
//        loadData()
//    }
//
//    deinit {
//        saveData()
//    }
//}
//
//extension WatchlistController2 {
//    struct WatchlistItem: Codable, Equatable {
//        var movie: Movie
//        var added: Date
//    }
//
//    enum SortingKey {
//        case date, title
//    }
//}
