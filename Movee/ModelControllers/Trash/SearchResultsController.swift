//
//  PeopleController.swift
//  Movee
//
//  Created by jjurlits on 2/17/21.
//

import Foundation


//
//class SearchResultsController {
//    enum ResultType: String, CaseIterable {
//        case all = "All Results"
//        case movies = "Movies"
//        case tvs = "TV Shows"
//        case people = "People"
//
//        static var titles: [String] {
//            return self.allCases.compactMap { $0.rawValue }
//        }
//    }
//
//    var query: String = ""
//    var filter = ResultType.all
//
//    private var _results = [SearchResult]()
//    private var task: URLSessionTask?
//
//    private var lastLoadedPage: Int = 0
//    private var shouldLoadMore: Bool = false
//
//    private func managePagedResult(_ pagedResult: PagedSearchResult) {
//        for result in pagedResult.results {
//            if !_results.contains(result), result != .empty {
//                _results.append(result)
//            }
//        }
//
//        lastLoadedPage = pagedResult.page
//        if pagedResult.total_pages > pagedResult.page && pagedResult.page < pagedResult.total_pages {
//            shouldLoadMore = true
//        }
//    }
//
//    private func fetched(result: Result<PagedSearchResult, Error>,
//                                          completion: @escaping (SearchResultsController) -> Void) {
//        switch result {
//        case .success(let pagedResult):
//            self.managePagedResult(pagedResult)
//            completion(self)
//        case .failure(let error):
//            print(error)
//        }
//    }
//
//
//    private func fetch(page: Int, completion: @escaping (SearchResultsController) -> Void) {
//        switch filter {
//        case .all:
//            task = TMDBClient.shared.searchMulti(query: query, page: page) { [weak self] result in
//                self?.fetched(result: result, completion: completion)
//            }
//        case .movies:
//            task = TMDBClient.shared.searchMovies(query: query, page: page) { [weak self] result in
//                self?.fetched(result: result, completion: completion)
//            }
//        case .tvs:
//            task = TMDBClient.shared.searchTVShows(query: query, page: page) { [weak self] result in
//                self?.fetched(result: result, completion: completion)
//            }
//
//        case .people:
//            task = TMDBClient.shared.searchPeople(query: query, page: page) { [weak self] result in
//                self?.fetched(result: result, completion: completion)
//            }
//        default:
//            return
//        }
//    }
//
//    fileprivate func filterResults() -> [SearchResult] {
//        var results = [SearchResult]()
//
//        switch filter {
//        case .movies:
//            results = _results.filter {
//                if case SearchResult.movie(_) = $0 { return true }
//                return false
//            }
//        case .people:
//            results = _results.filter {
//                if case SearchResult.character(_) = $0 { return true }
//                return false
//            }
//        default:
//            results = _results
//        }
//
//        return results
//    }
//
//    var resutls: [SearchResult] {
//        let results = filterResults()
//
//        if shouldLoadMore {
//            return results + [SearchResult.empty]
//        } else { return results }
//    }
//
//    func loadMore(completion: @escaping (SearchResultsController) -> Void) {
//        if shouldLoadMore {
//            fetch(page: lastLoadedPage + 1, completion: completion)
//        }
//    }
//
//    func load(completion: @escaping (SearchResultsController) -> Void) {
//        fetch(page: 1, completion: completion)
//    }
//
//    init(query: String) {
//        self.query = query
//    }
//
//    deinit {
//        task?.cancel()
//    }
//}
