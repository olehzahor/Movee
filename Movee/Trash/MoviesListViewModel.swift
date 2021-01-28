////
////  MoviesListViewModel.swift
////  Movee
////
////  Created by jjurlits on 11/18/20.
////
//
//import Foundation
//import UIKit
//
//protocol MoviesListViewModelDelegate: class {
//    func didFinishLoading(viewModel: MoviesListViewModel, snapshot: MoviesController.Snapshot)
//    func didFinishLoading()
//}
//
//extension MoviesListViewModelDelegate {
//    func didFinishLoading() { }
//}
//
//class MoviesListViewModel {
//    private var genres: Genres?
//    private var locale: String
//    private var list: MoviesList
//    var task: URLSessionTask?
//
//    //var snapshot = Snapshot()
//    weak var delegate: MoviesListViewModelDelegate?
//
//    private let emptyContainer = MovieContainer(id: -1)
//
//    private var isOnLastPage: Bool {
//        return list.total == list.loaded
//    }
//
//    private func isPreloaded(index: Int) -> Bool {
//        return list.contains(id: index)
//    }
//
//
//    private func createGenresStringList(from ids: [Int]) -> [String] {
//        guard let genres = genres else {
//            return []
//        }
//        return ids.compactMap({genres.name(for: $0)})
//    }
//
//    private func createSnapshot() {
//        let emptyContainer = -1
////        let lastUpdated = list.lastUpdated.compactMap { $0.id }
////        snapshot.deleteItems([emptyContainer])
////        snapshot.appendItems(lastUpdated)
////
////        if !isOnLastPage {
////            snapshot.appendItems([emptyContainer])
////        }
////
////        delegate?.didFinishLoading(viewModel: self, snapshot: self.snapshot)
//    }
//
//    private func update(with pagedResult: MoviesPagedResult) {
//        list.update(with: pagedResult)
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
//        guard list.total > 0 else { return 0 }
//
//        if isOnLastPage {
//            return list.count
//        } else {
//            return list.count + 1
//        }
//    }
//
//    func movieViewModel(at index: Int) -> MovieViewModel? {
//        print("asked for vm at index \(index)")
//        guard let movie = list[index]?.movie else {
//            if index <= list.total {
//                print("vm at \(index) not found")
//                fetch(page: list.nextPageToLoad)
//            }
//            return nil
//        }
//        return MovieViewModel(movie: movie, genres: genres)
//    }
//
//    func movie(at index: Int) -> Movie? {
//        guard let movie = list[index]?.movie else {
//            if index <= list.total {
//                fetch(page: list.nextPageToLoad)
//            }
//            return nil
//        }
//        return movie
//    }
//
//    init(locale: String = "en_US", initialPage: Int = 1) {
//        self.locale = locale
//
//        list = MoviesList()
//        //snapshot.appendSections([.main])
//
//        performInitialFetches(initialPage: initialPage)
//    }
//
//    func stopFetching() {
//        task?.cancel()
//    }
//
//    deinit {
//        stopFetching()
//        print("stoped")
//    }
//}
