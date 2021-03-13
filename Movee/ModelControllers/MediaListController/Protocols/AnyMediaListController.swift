//
//  AnyMediaListController.swift
//  Movee
//
//  Created by jjurlits on 3/11/21.
//

import Foundation
//replace medias with view models
protocol AnyMediaListController {
    typealias CompletionHandler = () -> Void
    func load(fromPage initialPage: Int, infiniteScroll: Bool, completion: @escaping CompletionHandler)
    func loadMore(completion: @escaping CompletionHandler)
    func stop()
    var title: String { get }
    var medias: [AnyHashable] { get }
    
}

extension AnyMediaListController {
    func load(completion: @escaping CompletionHandler) {
        return load(fromPage: 1, infiniteScroll: true, completion: completion)
    }
}
