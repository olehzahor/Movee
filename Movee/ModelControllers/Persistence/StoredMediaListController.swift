//
//  StoredMediaListController.swift
//  Movee
//
//  Created by jjurlits on 3/15/21.
//

import Foundation

struct StoredMediaListItem: Codable, Equatable, Hashable {
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

class StoredMediaListController: AsynchronousJSONPersistenceController<StoredMediaListItem> {
    
    internal var group = DispatchGroup()
    enum SortingKey { case date, title }

    public var sortingKey: SortingKey = .date
    public var sortAscending: Bool = true
        
    internal func postLoaded() { }
    internal func postUpdated() { }
    
    override func saveData() {
        super.saveData()
        postUpdated()
    }
    
    override func loadData(completion: (() -> Void)? = nil) {
        group.enter()
        super.loadData() {
            self.group.leave()
            self.postLoaded()
            completion?()
        }
    }
    
    func clear() {
        items = []
        saveData()
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

    func list() -> [StoredMediaListItem] {
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
}

extension StoredMediaListController: AnyMediaListController {
    @objc var title: String { return "" }

    func load(fromPage initialPage: Int, infiniteScroll: Bool, completion: @escaping CompletionHandler) {
        DispatchQueue.global(qos: .utility).async {
            switch self.dataState {
            case .loading:
                self.group.notify(queue: .main) { completion() }
            case .loaded:
                DispatchQueue.main.async { completion() }
            case .notLoaded:
                self.loadData(completion: completion)
            default:
                return
            }
        }
    }
    
    var medias: [AnyHashable] {
        return list().compactMap {
            $0.movie as AnyHashable? ?? $0.tvShow as AnyHashable?
        }
    }
    
    func loadMore(completion: CompletionHandler) { }
    func stop() { }
}
