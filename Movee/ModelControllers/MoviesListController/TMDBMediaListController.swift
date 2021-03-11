//
//  TMDBMediaListController.swift
//  Movee
//
//  Created by jjurlits on 3/2/21.
//

import Foundation

extension MediaListController {
    func load(completion: @escaping CompletionHandler) {
        return load(fromPage: 1, infiniteScroll: true, completion: completion)
    }
}



class TMDBMediaListController<T: Media>: MediaListController {
    typealias UpdateHandler = (TMDBMediaListController) -> ()
    typealias FetchRequest = (Int, @escaping (Result<MediaPagedResult<T>, Error>) -> Void) -> URLSessionTask?

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
    
    var medias: [Media] {
        if list.items.isEmpty, let savedList = savedList {
            var medias = savedList.items.compactMap { $0.media }
            if !list.isOnLastPage && addPlaceholders {
                medias.append(T.placeholder())
            }
            return medias
        }
        
        var medias = list.items.compactMap { $0.media }
        if !list.isOnLastPage && addPlaceholders {
            medias.append(T.placeholder())
        }
        return medias
    }
        
    private func performInitialFetches(initialPage: Int, completion: @escaping CompletionHandler) {
        let storedGenres = TMDBClient.shared.genres
        if T.self == Movie.self, storedGenres.movie == nil {
            TMDBClient.shared.loadMovieGenres { _ in
                self.fetch(page: initialPage, completion: completion)
            }
        } else if T.self == TVShow.self, storedGenres.tv == nil {
            TMDBClient.shared.loadTVGenres { _ in
                self.fetch(page: initialPage, completion: completion)
            }
        } else { self.fetch(page: initialPage, completion: completion) }
    }

    private func fetch(page: Int, completion: @escaping CompletionHandler) {
        task = fetchRequest?(page) { [weak self] result in
            self?.genericCompletionHandler(result: result, completion: completion)
        }
    }
    
    private func genericCompletionHandler(result: Result<MediaPagedResult<T>, Error>, completion: @escaping CompletionHandler) {
        //print(result)
        switch result {
        case .success(let mediaPagedResult):
            self.list.update(with: mediaPagedResult)
            completion()
            
        case .failure(let error):
            print(error)
            self.lastError = error
            completion()
        }
        //completion?()
    }
        
    private func reset() {
        task?.cancel()
        list = MediaList<T>()
    }
    
    init(title: String = "", fetchRequest: @escaping FetchRequest) {
        self.title = title
        self.fetchRequest = fetchRequest
    }
    
    deinit {
        task?.cancel()
    }
    
    static func customList(title: String, path: String, query: String) -> TMDBMediaListController<T> {
        return  TMDBMediaListController<T>(title: title) { page, completion in
            TMDBClient.shared.customList(page: page, path: path, query: query, completion: completion)
        }
    }
    
    static func moviesSearchResult(query: String) -> TMDBMediaListController<Movie> {
        return TMDBMediaListController<Movie> { page, completion in
            TMDBClient.shared.searchMovies(query: query, page: page, completion: completion)
        }
    }
    
    static func tvShowsSearchResult(query: String) -> TMDBMediaListController<TVShow> {
        return TMDBMediaListController<TVShow> { page, completion in
            TMDBClient.shared.searchTVShows(query: query, page: page, completion: completion)
        }
    }


}


//        if let genres = TMDBClient.shared.genres.movie {
//            //self.genres = genres
//            fetch(page: initialPage, completion: completion)
//        } else {
//            let group = DispatchGroup()
//            group.enter()
//            TMDBClient.shared.loadMovieGenres() { genres in
//                //self.genres = genres
//                group.leave()
//            }
//            group.notify(queue: .main) {
//                self.fetch(page: initialPage, completion: completion)
//            }
//        }
