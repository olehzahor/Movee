//
//  WatchlistController.swift
//  Movee
//
//  Created by jjurlits on 12/9/20.
//

import Foundation

struct WatchlistItem: Codable, Equatable, Hashable {
    var movie: Movie?
    var tvShow: TVShow?
    var mediaType: MediaType?
    var added: Date
    
    init(movie: Movie, added: Date! = Date()) {
        self.movie = movie.short
        self.added = added
        self.mediaType = .movie
    }
    
    init(tvShow: TVShow, added: Date! = Date()) {
        self.tvShow = tvShow.short
        self.added = added
        self.mediaType = .tvShow
    }
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
       
    func addMedia<T: Media>(_ media: T) {
        switch media.mediaType {
        case .movie:
            guard let movie = media as? Movie, !contains(movie) else { return }
            addItem(.init(movie: movie))
        case .tvShow:
            guard let tvShow = media as? TVShow, !contains(tvShow) else { return }
            addItem(.init(tvShow: tvShow))
        default:
            return
        }
        
    }
            
    func removeMedia<T: Media>(_ media: T) {
        items.removeAll {
            $0.movie?.id == media.id || $0.tvShow?.id == media.id }
        saveData()
    }
    
    func contains<T: Media>(_ media: T) -> Bool {
        let media = items.first {
            $0.movie?.id == media.id || $0.tvShow?.id == media.id }
        return media != nil
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
                return first.movie?.title ?? first.tvShow?.title ?? ""
                    > second.movie?.title ?? second.tvShow?.title ?? ""
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


extension WatchlistController: AnyMediaListController {
    @objc var title: String { return "Watchlist" }

    func load(fromPage initialPage: Int, infiniteScroll: Bool, completion: @escaping CompletionHandler) {
        DispatchQueue.global().async {
            if !self.isDataLoaded { self.loadData() }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    var medias: [AnyHashable] {
        return watchlist().compactMap {
            $0.movie as AnyHashable? ?? $0.tvShow as AnyHashable?
        }
    }
    
    func loadMore(completion: CompletionHandler) { }
    func stop() { }
}



//extension WatchlistController: MoviesListController {
//    var title: String { return "Watchlist" }
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
//        return watchlist().compactMap({ $0.movie })
//    }
//
//    func loadMore(completion: CompletionHandler) { }
//    func stop() { }
//}
//
