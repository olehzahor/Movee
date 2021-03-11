//
//  AnyTMDBList.swift
//  Movee
//
//  Created by jjurlits on 3/3/21.
//

import Foundation

protocol TMDBMediaResponse: Hashable, Decodable, Identifiable {
    static var placeholder: Self { get }
}


struct AnyMediaPagedResult<T: TMDBMediaResponse>: Hashable, Decodable {
    var results: [T]
    var total_results: Int
    var total_pages: Int
    var page: Int
}

struct AnyMediaContainer<T: TMDBMediaResponse>: Hashable {
    var id: T.ID
    var index: Int?
    var page: Int?
    var media: T?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct AnyMediaList<T: TMDBMediaResponse> {
    internal var items = [AnyMediaContainer<T>]()
    private var pages: Int = 0
    private var total: Int = 0
    private var newItemIndex: Int = 0
    private var loadedPages: [Int] = [Int]()
    private var lastLoadedPage: Int = 0
    
    var nextPageToLoad: Int {
        return lastLoadedPage + 1
    }
    
    private var itemsOnPage: Int {
        return Int(total / pages)
    }
    
    private var loaded: Int {
        return items.count
    }
    
    private subscript(index: Int) -> AnyMediaContainer<T>? {
        return items.first(where: { $0.index == index })
    }
    
    private var count: Int {
        return loaded
    }
    
    private func contains(id: T.ID) -> Bool {
        return items.contains(where: { $0.id == id })
    }
    
    private func contains(index: Int) -> Bool {
        return items.contains(where: { $0.index == index })
    }
    
    var isOnLastPage: Bool {
        return total == loaded
    }
    
    //TODO: update existing page
    mutating func update(with pagedResult: AnyMediaPagedResult<T>) {
        let page = pagedResult.page
        
        if loadedPages.contains(page) { return }
        
        loadedPages.append(page)
        lastLoadedPage = page
        total = pagedResult.total_results
        pages = pagedResult.total_pages
        
        for media in pagedResult.results {
            if self.contains(id: media.id) { continue }
            
            let container = AnyMediaContainer(
                id: media.id, index: newItemIndex, page: page, media: media)
            
            items.append(container)
            newItemIndex += 1
        }
    }
}

protocol AnyMediaListControllerProtocol {
    typealias CompletionHandler = () -> Void
    func load(fromPage initialPage: Int, infiniteScroll: Bool, completion: @escaping CompletionHandler)
    func loadMore(completion: @escaping CompletionHandler)
    func stop()
    var title: String { get }
    var medias: [AnyHashable] { get }
}

extension AnyMediaListControllerProtocol {
    func load(completion: @escaping CompletionHandler) {
        return load(fromPage: 1, infiniteScroll: true, completion: completion)
    }
}


class AnyMediaListController<T: TMDBMediaResponse>: AnyMediaListControllerProtocol {
    typealias UpdateHandler = (AnyMediaListController) -> ()
    typealias FetchRequest = (Int, @escaping (Result<AnyMediaPagedResult<T>, Error>) -> Void) -> URLSessionTask?

    var fetchRequest: FetchRequest?
    var addPlaceholders: Bool = true
    
    var lastError: Error?
    
    private(set) var title: String
    
    internal var list: AnyMediaList<T> = AnyMediaList<T>()
    private var savedList: AnyMediaList<T>?
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
//        let storedGenres = TMDBClient.shared.genres
//        if T.self == Movie.self, storedGenres.movie == nil {
//            TMDBClient.shared.loadMovieGenres { _ in
//                self.fetch(page: initialPage, completion: completion)
//            }
//        } else if T.self == TVShow.self, storedGenres.tv == nil {
//            TMDBClient.shared.loadTVGenres { _ in
//                self.fetch(page: initialPage, completion: completion)
//            }
//        } else { self.fetch(page: initialPage, completion: completion) }
    }

    private func fetch(page: Int, completion: @escaping CompletionHandler) {
        task = fetchRequest?(page) { [weak self] result in
            self?.genericCompletionHandler(result: result, completion: completion)
        }
    }
    
    private func genericCompletionHandler(result: Result<AnyMediaPagedResult<T>, Error>, completion: @escaping CompletionHandler) {
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
        list = AnyMediaList<T>()
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
    static func peopleSearchResult(query: String) -> AnyMediaListController<Character> {
        return .init { (page, completion) -> URLSessionTask? in
            TMDBClient.shared.searchPeople(query: query, page: page, completion: completion)
        }
    }
        
    static func moviesSearchResult(query: String) -> AnyMediaListController<Movie> {
        return .init { page, completion in
            TMDBClient.shared.searchMovies(query: query, page: page, completion: completion)
        }
    }
    
    static func tvShowsSearchResult(query: String) -> AnyMediaListController<TVShow> {
        return .init { page, completion in
            TMDBClient.shared.searchTVShows(query: query, page: page, completion: completion)
        }
    }

}
