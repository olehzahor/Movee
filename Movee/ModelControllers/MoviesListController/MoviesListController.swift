//
//  MoviesListController.swift
//  Movee
//
//  Created by jjurlits on 1/14/21.
//

import Foundation

protocol MoviesListController {
    typealias CompletionHandler = (MoviesListController) -> Void
    typealias FetchRequest = (Int, @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask?
    func load(fromPage initialPage: Int, infiniteScroll: Bool, completion: @escaping CompletionHandler)
    func loadMore(completion: @escaping CompletionHandler)
    //func update()
    func stop()
    //func reload(fromPage initialPage: Int, completion: CompletionHandler?, infiniteScroll: Bool)
    var title: String { get }
    var movies: [Movie] { get }
    //var fetchRequest: FetchRequest? { get set }
}

extension MoviesListController {
    func load(completion: @escaping CompletionHandler) {
        return load(fromPage: 1, infiniteScroll: true, completion: completion)
    }
}
