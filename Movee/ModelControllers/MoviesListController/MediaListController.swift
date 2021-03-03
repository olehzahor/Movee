//
//  MediaListController.swift
//  Movee
//
//  Created by jjurlits on 3/2/21.
//

import Foundation

protocol MediaListController {
    typealias CompletionHandler = () -> Void
    func load(fromPage initialPage: Int, infiniteScroll: Bool, completion: @escaping CompletionHandler)
    func loadMore(completion: @escaping CompletionHandler)
    func stop()
    var title: String { get }
    var medias: [Media] { get }
}
