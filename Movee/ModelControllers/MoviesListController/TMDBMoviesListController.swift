//
//  WIP-MoviesListController.swift
//  Movee
//
//  Created by jjurlits on 1/3/21.
//

import Foundation

class TMDBMoviesListController: MoviesListController {
    typealias UpdateHandler = (MoviesListController) -> ()
    typealias FetchRequest = (Int, @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask?

    var fetchRequest: FetchRequest?
    var addPlaceholders: Bool = true
    
    var lastError: Error?
    
    private(set) var title: String
    
    internal var list: MoviesList = MoviesList()
    private var savedList: MoviesList?
    private var genres: Genres?
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
    
    var movies: [Movie] {
        if list.items.isEmpty, let savedList = savedList {
            var movies = savedList.items.compactMap { $0.movie }
            if !list.isOnLastPage && addPlaceholders {
                movies.append(Movie.placeholder)
            }
            return movies
        }
        
        var movies = list.items.compactMap { $0.movie }
        if !list.isOnLastPage && addPlaceholders {
            movies.append(Movie.placeholder)
        }
        return movies
    }
        
    private func performInitialFetches(initialPage: Int, completion: @escaping CompletionHandler) {
        if let genres = TMDBClient.shared.genres {
            self.genres = genres
            fetch(page: initialPage, completion: completion)
        } else {
            let group = DispatchGroup()
            group.enter()
            TMDBClient.shared.loadGenres() { genres in
                self.genres = genres
                group.leave()
            }
            group.notify(queue: .main) {
                self.fetch(page: initialPage, completion: completion)
            }
        }
    }

    private func fetch(page: Int, completion: @escaping CompletionHandler) {
        task = fetchRequest?(page) { [weak self] result in
            self?.genericCompletionHandler(result: result, completion: completion)
        }
    }
    
    private func genericCompletionHandler(result: Result<MoviesPagedResult, Error>, completion: @escaping CompletionHandler) {
        //print(result)
        switch result {
        case .success(let moviesPagedResult):
            self.list.update(with: moviesPagedResult)
            completion(self)
            
        case .failure(let error):
            print(error)
            self.lastError = error
            completion(self)
        }
        //completion?()
    }
        
    private func reset() {
        task?.cancel()
        list = MoviesList()
    }
    
    init(title: String = "", fetchRequest: @escaping FetchRequest) {
        self.title = title
        self.fetchRequest = fetchRequest
    }
    
    deinit {
        task?.cancel()
    }
}

extension TMDBMoviesListController {
    static func customList(title: String, path: String, query: String) -> MoviesListController {
        return TMDBMoviesListController(title: title) { page, completion in
            TMDBClient.shared.customList(page: page, path: path, query: query, completion: completion)
        }
    }
    
    static var popularList: MoviesListController = {
        return TMDBMoviesListController(title: "Popular Movies") { page, completion in
            TMDBClient.shared.getPopularMovies(page: page, completion: completion)
        }
    }()
    
    static func relatedList(to movie: Movie) -> MoviesListController? {
        guard let movieId = movie.id else { return nil }
        return TMDBMoviesListController(title: "Similiar to \(movie.title ?? "")") { page, completion in
            TMDBClient.shared.getRelatedMovies(movieId: movieId, page: page, completion: completion)
        }
    }
    
    static func relatedList(toMovieId movieId: Int) -> MoviesListController {
        return TMDBMoviesListController(title: "Similiar Movies") { page, completion in
            TMDBClient.shared.getRelatedMovies(movieId: movieId, page: page, completion: completion)
        }
    }
    
    static func filteredList(filter: Filter, title: String = "") -> MoviesListController {
        return TMDBMoviesListController(title: title) { page, completion in
            TMDBClient.shared.discoverMovies(page: page, filter: filter, completion: completion)
        }
    }
    
    static func searchResults(query: String) -> MoviesListController {
        return TMDBMoviesListController() { page, completion in
            return TMDBClient.shared.searchMovies(query: query, page: page, completion: completion)
        }
    }
}
