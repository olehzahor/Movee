
//
//
//class MoviesListController2 {
//    typealias UpdateHandler = (MoviesListController2) -> ()
//    typealias ErrorHandler = (Error) -> ()
//    typealias FetchRequest = (Int, @escaping (Result<MoviesPagedResult, Error>) -> Void)->URLSessionTask?
//
//    var errorHandler: ErrorHandler?
//    var updateHandler: UpdateHandler?
//    var fetchRequest: FetchRequest?
//    var addPlaceholders: Bool = true
//
//    private(set) var title: String
//
//    internal var list: MoviesList = MoviesList()
//    private var savedList: MoviesList?
//    private var genres: Genres?
//    private var task: URLSessionTask?
//
//    func loadMore() {
//        fetch(page: list.nextPageToLoad)
//    }
//
//    func load() {
//        load(fromPage: 1)
//    }
//
//    func load(fromPage initialPage: Int) {
//        performInitialFetches(initialPage: initialPage)
//    }
//
//    func reload() {
//        reset()
//        load()
//    }
//
//    func stop() {
//        task?.cancel()
//    }
//
//    var movies: [Movie] {
//        if list.items.isEmpty, let savedList = savedList {
//            var movies = savedList.items.compactMap { $0.movie }
//            if !list.isOnLastPage && addPlaceholders {
//                movies.append(Movie.placeholder)
//            }
//            return movies
//        }
//
//        var movies = list.items.compactMap { $0.movie }
//        if !list.isOnLastPage && addPlaceholders {
//            movies.append(Movie.placeholder)
//        }
//        return movies
//    }
//
//    private func performInitialFetches(initialPage: Int) {
//        if let genres = TMDBClient.shared.genres {
//            self.genres = genres
//            fetch(page: initialPage)
//        } else {
//            let group = DispatchGroup()
//            group.enter()
//            TMDBClient.shared.loadGenres() { genres in
//                self.genres = genres
//                group.leave()
//            }
//            group.notify(queue: .main) {
//                self.fetch(page: initialPage)
//            }
//        }
//    }
//
//    private func fetch(page: Int, completion: (() -> ())? = nil) {
//        task = fetchRequest?(page) { [weak self] result in
//            self?.genericCompletionHandler(result: result, completion: completion)
//        }
//    }
//
//    private func genericCompletionHandler(result: Result<MoviesPagedResult, Error>,
//                                           completion: (() -> ())? = nil) {
//        //print(result)
//        switch result {
//        case .success(let moviesPagedResult):
//            self.list.update(with: moviesPagedResult)
//            updateHandler?(self)
//        case .failure(let error):
//            print(error)
//            errorHandler?(error)
//        }
//        completion?()
//    }
//
//    private func reset() {
//        task?.cancel()
//        list = MoviesList()
//    }
//
//    init(title: String = "", fetchRequest: @escaping FetchRequest) {
//        self.title = title
//        self.fetchRequest = fetchRequest
//    }
//
//    deinit {
//        task?.cancel()
//    }
//}


////
////  MovieResult.swift
////  Movee
////
////  Created by jjurlits on 10/27/20.
////
//
//import Foundation
//
//class MoviesListController {
//    typealias UpdateHandler = (MoviesListController) -> ()
//    typealias ErrorHandler = (Error) -> ()
//
//    var errorHandler: ErrorHandler?
//    var updateHandler: UpdateHandler?
//    
//    internal var list: MoviesList
//    private var savedList: MoviesList?
//    private var genres: Genres?
//    private var task: URLSessionTask?
//    
//    private(set) var listType: ListType {
//        didSet {
//            reset()
//        }
//    }
//    
//    func loadMore() {
//        fetch(page: list.nextPageToLoad)
//    }
//    
//    func load(fromPage initialPage: Int = 1) {
//        performInitialFetches(initialPage: initialPage)
//    }
//    
//    func reload() {
//        savedList = list
//        reset()
//        load()
//    }
//    
//    var movies: [Movie] {
//        if list.items.isEmpty, let savedList = savedList {
//            var movies = savedList.items.compactMap { $0.movie }
//            if !list.isOnLastPage {
//                movies.append(Movie.placeholder)
//            }
//            return movies
//        }
//        
//        var movies = list.items.compactMap { $0.movie }
//        if !list.isOnLastPage {
//            movies.append(Movie.placeholder)
//        }
//        return movies
//    }
//    
//    func changeListType(to newListType: ListType, savePrevious: Bool = false) {
//        print("list type changed to \(newListType)")
//        if savePrevious {
//            savedList = list
//        }
//        listType = newListType
//    }
//    
//    func loadSavedState() {
//        if let savedList = savedList {
//            list = savedList
//            updateHandler?(self)
//        }
//    }
//        
//    private func performInitialFetches(initialPage: Int) {
//        if let genres = TMDBClient.shared.genres {
//            self.genres = genres
//            fetch(page: initialPage)
//        } else {
//            let group = DispatchGroup()
//            group.enter()
//            TMDBClient.shared.loadGenres() { genres in
//                self.genres = genres
//                group.leave()
//            }
//            group.notify(queue: .main) {
//                self.fetch(page: initialPage)
//            }
//        }
//    }
//    
//    private func populateFromWatchlist() {
//        let watchlistController = WatchlistController()
//        let watchlist = watchlistController.watchlist()
//        let movies = watchlist.compactMap { $0.movie }
//        let results = MoviesPagedResult(results: movies, total_results: movies.count, total_pages: 1, page: 1)
//        self.list.update(with: results)
//        updateHandler?(self)
//    }
//    
////    internal func fetch(page: Int, completion: (() -> ())? = nil) {
////        task = listType.fetchRequest(page: page) { result in
////            self.genericCompletionHandler(result: result, completion: completion)
////        }
////    }
////
//    internal func fetch(page: Int, completion: (() -> ())? = nil) {
//        switch listType {
//        case .custom(_, let fetchRequest):
//            fetchRequest(page) { result in
//                self.genericCompletionHandler(result: result, completion: completion)
//            }
//        case .watchlist:
//            populateFromWatchlist()
//        case .popular:
//            TMDBClient.shared.getPopularMovies(page: page) { result in
//                self.genericCompletionHandler(result: result, completion: completion)
//            }
//        case .related(let movie):
//            guard let movieId = movie.id else { return }
//            TMDBClient.shared.getRelatedMovies(movieId: movieId, page: page) { result in
//                self.genericCompletionHandler(result: result, completion: completion)
//            }
//        case .search(let query):
//            task = TMDBClient.shared.searchMovies(query: query, page: list.nextPageToLoad) { result in
//                self.genericCompletionHandler(result: result, completion: completion)
//            }
//        case .filtered(_, let filter):
//            TMDBClient.shared.discoverMovies(page: page, filter: filter) {
//                result in
//                self.genericCompletionHandler(result: result, completion: completion)
//            }
//        default:
//            return
//        }
//    }
//    
//    private func genericCompletionHandler(result: Result<MoviesPagedResult, Error>,
//                                           completion: (() -> ())? = nil) {
//        switch result {
//        case .success(let moviesPagedResult):
//            self.list.update(with: moviesPagedResult)
//            updateHandler?(self)
//        case .failure(let error):
//            print(error)
//            errorHandler?(error)
//        }
//        completion?()
//    }
//        
//    private func reset() {
//        task?.cancel()
//        list = MoviesList()
//    }
//    
//    init(type: ListType, updateHandler: @escaping UpdateHandler) {
//        self.listType = type
//        self.updateHandler = updateHandler
//        self.list = MoviesList()
//    }
//}
//
//
//extension MoviesListController {
//    enum ListType {
//        case popular, credited
//        case related(Movie)
//        case search(String)
//        case watchlist
//        case filtered(String, Filter)
//        
//        case custom(String, (Int, @escaping (Result<MoviesPagedResult, Error>) -> Void)->Void)
//                
//        var title: String? {
//            switch self {
//            case .popular:
//                return "Popular Movies"
//            case .search(_):
//                return "Search"
//            case .watchlist:
//                return "Watchlist"
//            case .related(let movie):
//                if let title = movie.title {
//                    return "Similiar to \(title)"
//                } else {
//                    return nil
//                }
//            case .filtered(let title, _):
//                return title
//            case .custom(let title, _):
//                return title
//            default:
//                return nil
//            }
//        }
//    }
//    
//    struct MovieContainer: Hashable {
//        var id: Int
//        var index: Int?
//        var page: Int?
//        var movie: Movie?
//        
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(id)
//        }
//    }
//}
//
//extension MoviesListController {
//    internal struct MoviesList {
//        internal var items = [MovieContainer]()
//        private var pages: Int = 0
//        private var total: Int = 0
//        private var newItemIndex: Int = 0
//        private var loadedPages: [Int] = [Int]()
//        private var lastLoadedPage: Int = 0
//        
//        var nextPageToLoad: Int {
//            return lastLoadedPage + 1
//        }
//        
//        private var itemsOnPage: Int {
//            return Int(total / pages)
//        }
//        
//        private var loaded: Int {
//            return items.count
//        }
//        
//        private subscript(index: Int) -> MovieContainer? {
//            return items.first(where: { $0.index == index })
//        }
//        
//        private var count: Int {
//            return loaded
//        }
//        
//        private func contains(id: Int) -> Bool {
//            return items.contains(where: { $0.id == id })
//        }
//        
//        private func contains(index: Int) -> Bool {
//            return items.contains(where: { $0.index == index })
//        }
//        
//        var isOnLastPage: Bool {
//            return total == loaded
//        }
//        
//        //TODO: update existing page
//        mutating func update(with pagedResult: MoviesPagedResult) {
//            let page = pagedResult.page
//            
//            if loadedPages.contains(page) { return }
//            
//            loadedPages.append(page)
//            lastLoadedPage = page
//            total = pagedResult.total_results
//            pages = pagedResult.total_pages
//            
//            for movie in pagedResult.results {
//                guard let movieId = movie.id,
//                      !items.contains(where: { $0.id == movieId })
//                else { continue }
//                
//                let container = MovieContainer(
//                    id: movieId, index: newItemIndex, page: page, movie: movie
//                )
//                
//                items.append(container)
//                newItemIndex += 1
//            }
//        }
//    }
//}
