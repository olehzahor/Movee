//
//  SinglePageMediaListController.swift
//  Movee
//
//  Created by jjurlits on 3/17/21.
//

import Foundation

protocol SinglePageMediaListContainer: Codable {
    var medias: [AnyHashable] { get }
}

class SinglePageMediaListController<T: SinglePageMediaListContainer>: AnyMediaListController {
    typealias FetchRequest = (@escaping (Result<T, Error>) -> Void) -> URLSessionTask?

    var title: String
    var medias: [AnyHashable] = []

    var task: URLSessionTask?
    var fetchRequest: FetchRequest?
    
    private func fetch(completion: @escaping CompletionHandler) {
        task = fetchRequest?() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.medias = result.medias
                completion()
            case .failure(let error):
                print(error)
                self.medias = []
                completion()
            }
        }
    }

    func load(fromPage initialPage: Int, infiniteScroll: Bool, completion: @escaping CompletionHandler) {
        fetch(completion: completion)
    }
    
    func loadMore(completion: @escaping CompletionHandler) {
        completion()
    }
    
    func stop() {
        task?.cancel()
    }
        
    init(title: String, fetchRequest: @escaping FetchRequest) {
        self.title = title
        self.fetchRequest = fetchRequest
    }
}


extension SinglePageMediaListController {
    static func customSinglePageList(title: String, path: String) -> SinglePageMediaListController<T> {
        return SinglePageMediaListController<T>(title: title) { (completion) -> URLSessionTask? in
            return TMDBClient.shared.customSinglePageList(path: path, completion: completion)
        }
    }
}
