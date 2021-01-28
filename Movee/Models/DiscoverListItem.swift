//
//  DiscoverListItem.swift
//  Movee
//
//  Created by jjurlits on 1/9/21.
//

import Foundation

class DiscoverListItem: Codable {
    let name: String
    let path: String?
    let query: String?
    let nestedLists: [DiscoverListItem]
    
    init(name: String, path: String, query: String) {
        self.name = name
        self.path = path
        self.query = query
        self.nestedLists = []
    }
    
    init(name: String, nestedLists: [DiscoverListItem]) {
        self.name = name
        self.nestedLists = nestedLists
        self.path = nil
        self.query = nil
    }
}

extension DiscoverListItem {
    var moviesController: MoviesListController? {
        guard let path = path, let query = query else { return nil }
        return TMDBMoviesListController.customList(title: name, path: path, query: query)
    }
}

extension DiscoverListItem: Hashable {
    static func == (lhs: DiscoverListItem, rhs: DiscoverListItem) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(path)
        hasher.combine(query)
        hasher.combine(nestedLists)
    }
}
