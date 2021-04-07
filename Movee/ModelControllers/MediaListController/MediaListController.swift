//
//  AnyTMDBList.swift
//  Movee
//
//  Created by jjurlits on 3/3/21.
//

import Foundation

class MediaListController<T: MediaListItem>: AnyMediaListController {
    typealias UpdateHandler = (AnyMediaListController) -> ()
    typealias FetchRequest = (Int, @escaping (Result<PagedResult<T>, Error>) -> Void) -> URLSessionTask?

    var fetchRequest: FetchRequest?
    var addPlaceholders: Bool = true
    
    var lastError: Error?
    
    private(set) var title: String
    
    internal var list: MediaList<T> = MediaList<T>()
    private var savedList: MediaList<T>?
    private var task: URLSessionTask?
    
    func loadMore(completion: @escaping CompletionHandler) {
        fetch(page: list.nextPageToLoad, completion: completion)
    }
        
    func load(fromPage initialPage: Int = 1, infiniteScroll: Bool = true, completion: @escaping CompletionHandler) {
        addPlaceholders = infiniteScroll
        performInitialFetches(initialPage: initialPage, completion: completion)
    }
    
    func reload(completion: @escaping CompletionHandler) {
        reset()
        load(completion: completion)
    }
    
    func stop() {
        task?.cancel()
    }
    
    var medias: [AnyHashable] {
        if list.items.isEmpty, let savedList = savedList {
            var medias = savedList.items.compactMap { $0.media }
            if !list.isOnLastPage && addPlaceholders {
                medias.append(T.placeholder)
            }
            return medias
        }
        
        var medias = list.items.compactMap { $0.media }
        if !list.isOnLastPage && addPlaceholders {
            medias.append(T.placeholder)
        }
        return medias
    }
        
    private func performInitialFetches(initialPage: Int, completion: @escaping CompletionHandler) {
        self.fetch(page: initialPage, completion: completion)
    }

    private func fetch(page: Int, completion: @escaping CompletionHandler) {
        task = fetchRequest?(page) { [weak self] result in
            self?.genericCompletionHandler(result: result, completion: completion)
        }
    }
    
    private func genericCompletionHandler(result: Result<PagedResult<T>, Error>, completion: @escaping CompletionHandler) {
        switch result {
        case .success(let mediaPagedResult):
            self.list.update(with: mediaPagedResult)
            completion()
            
        case .failure(let error):
            print(error)
            self.lastError = error
            completion()
        }
    }
        
    private func reset() {
        task?.cancel()
        list = MediaList<T>()
    }
    
    required init(title: String = "", fetchRequest: @escaping FetchRequest) {
        self.title = title
        self.fetchRequest = fetchRequest
    }
    
    deinit {
        task?.cancel()
    }
}

extension AnyMediaListController {
    static func peopleSearchResult(query: String) -> MediaListController<Character> {
        return .init { (page, completion) -> URLSessionTask? in
            TMDBClient.shared.searchPeople(query: query, page: page, completion: completion)
        }
    }
        
    static func moviesSearchResult(query: String) -> MediaListController<Movie> {
        return .init { page, completion in
            TMDBClient.shared.searchMovies(query: query, page: page, completion: completion)
        }
    }
    
    static func tvShowsSearchResult(query: String) -> MediaListController<TVShow> {
        return .init { page, completion in
            TMDBClient.shared.searchTVShows(query: query, page: page, completion: completion)
        }
    }
    
    static func customMoviesList(title: String, path: String, query: String) -> MediaListController<Movie> {
        return .init(title: title) { page, completion in
            TMDBClient.shared.customList(page: page, path: path, query: query, completion: completion)
        }
    }
    
    static func customTVShowsList(title: String, path: String, query: String) -> MediaListController<TVShow> {
        return .init(title: title) { page, completion in
            TMDBClient.shared.customList(page: page, path: path, query: query, completion: completion)
        }
    }
    
    static func relatedMoviesList(movieId: Int, name: String = "") -> MediaListController<Movie> {
        let listTitle = "Similar to".l10ed + " \(name)"
        return .init(title: listTitle) { page, completion in
            TMDBClient.shared.getRelatedMovies(movieId: movieId, page: page, completion: completion)
        }
    }
    
    static func relatedTVShowsList(tvShowId: Int, name: String = "") -> MediaListController<TVShow> {
        let listTitle = "Similar to".l10ed + " \(name)"
        return .init(title: listTitle) { page, completion in
            TMDBClient.shared.getRelatedTVShows(tvShowId: tvShowId, page: page, completion: completion)
        }
    }
    
    static func filteredMovies(filter: Filter) -> MediaListController<Movie> {
        return .init { page, completion in
            TMDBClient.shared.discoverMovies(filter: filter, page: page, completion: completion)
        }
    }
    
    static func filteredTVShows(filter: Filter) -> MediaListController<TVShow> {
        return .init { page, completion in
            TMDBClient.shared.discoverTVShows(filter: filter, page: page, completion: completion)
        }
    }



}
