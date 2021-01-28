//
//class _MoviesListViewModel {
//    private var genres: Genres?
//    private var page: Int
//    private var locale: String
//    private var list: [Int: Movie]
//    private var pages: Int
//    private var lastMovieIndex: Int
//    private var total: Int
//    private var lastUpdated: [Int]
//    
//    var snapshot = Snapshot()
//    weak var delegate: MoviesListViewModelDelegate?
//    //private var shouldNotify = true
//    
//    private let emptyContainer = MovieContainer(id: -1)
//
//    private var isOnLastPage: Bool {
//        return total == loaded
//    }
//
//    private var loaded: Int {
//        return list.count
//    }
//    
//    private var resultsOnPage: Int {
//        //guard pages > 0 else { return 0 }
//        return Int(total / pages)
//    }
//    
//    private func page(where index: Int) -> Int {
//        return Int(index/resultsOnPage) + 1
//    }
//    
//    private func isPreloaded(index: Int) -> Bool {
//        return list.keys.contains(index)
//    }
//    
//    private func enumerate(_ movies: [Movie]) {
//        for movie in movies {
//            lastMovieIndex += 1
//            if list.values.contains(movie) {
//                list[lastMovieIndex] = nil
//            } else {
//                list[lastMovieIndex] = movie
//                lastUpdated.append(lastMovieIndex)
//            }
//        }
//    }
//    
//    private func createGenresStringList(from ids: [Int]) -> [String] {
//        guard let genres = genres else {
//            return []
//        }
//        return ids.compactMap({genres.name(for: $0)})
//    }
//    
//    private var lastUpdatedContainers: [MovieContainer] {
//        return lastUpdated.compactMap({list[$0]?.container})
//    }
//    
//    private func createSnapshot() {
//        let movies1 = snapshot.itemIdentifiers
//        let movies2 = lastUpdatedContainers
//        print(movies1.filter( {movies2.contains($0)}))
//        
//        snapshot.deleteItems([emptyContainer])
//        snapshot.appendItems(lastUpdatedContainers)
//            
//        
//        
//        
//        if !isOnLastPage {
//            snapshot.appendItems([emptyContainer])
//        }
//        
//       // delegate?.didFinishLoading(viewModel: self, snapshot: self.snapshot)
//    }
//    
//    private func update(with pagedResult: MoviesPagedResult) {
//        page = pagedResult.page
//        total = pagedResult.total_results
//        pages = pagedResult.total_pages
//        lastUpdated.removeAll()
//        enumerate(pagedResult.results)
//        
//        createSnapshot()
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
//    internal func fetch(page: Int, completion: (() -> ())? = nil) { }
//    
//    internal func genericCompletionHandler(result: Result<MoviesPagedResult, Error>,
//                                  completion: (() -> ())? = nil) {
//        switch result {
//        case .success(let moviesPagedResult):
//            self.update(with: moviesPagedResult)
//        case .failure(let error):
//            print(error)
//        }
//        completion?()
//    }
//
//
//    var rowsCount: Int {
//        guard total > 0 else { return 0 }
//        return total == loaded ? loaded : loaded + 1
//    }
//
//    func movieViewModel(at index: Int) -> MovieViewModel? {
//        guard list.keys.contains(index) else {
//            if index <= total {
//                fetch(page: page(where: index))
//            }
//            return nil
//        }
//        return MovieViewModel(movie: list[index]!, genres: genres)
//    }
//    
//    func movie(at index: Int) -> Movie? {
//        guard list.keys.contains(index) else {
//            fetch(page: page(where: index))
//            return nil
//        }
//        return list[index]
//    }
//    
//    init(locale: String = "en_US", initialPage: Int = 1) {
//        self.page = initialPage
//        self.locale = locale
//        self.list = [Int: Movie]()
//        self.pages = 1
//        self.total = 0
//        self.lastUpdated = [Int]()
//        self.lastMovieIndex = -1
//        snapshot.appendSections([.main])
//
//        performInitialFetches(initialPage: initialPage)
//    }
//    
//    deinit {
//        print("deinited")
//    }
//}
//
////func reset() {
////    list = [Int: Movie]()
////    page = 0
////    pages = 0
////    total = 0
////    lastUpdated = [Int]()
////    lastMovieIndex = -1
////    snapshot.deleteAllItems()
////    snapshot.appendSections([.main])
////}
//
////func getGenres
//
////    func fetchGenres(completion: @escaping () -> ()) {
////        TMDBClient.shared.getGenresList() { (result) in
////            switch result {
////            case .success(let genres):
////                self.genres = genres
////            case .failure(let error):
////                print(error)
////            }
////            completion()
////        }
////    }
//
