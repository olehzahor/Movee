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
    let mediaType: String?
    
    init(name: String, path: String, query: String, mediaType: String! = nil) {
        self.name = name
        self.path = path
        self.query = query
        self.nestedLists = []
        self.mediaType = mediaType
    }
    
    init(name: String, nestedLists: [DiscoverListItem]) {
        self.name = name
        self.nestedLists = nestedLists
        self.path = nil
        self.query = nil
        self.mediaType = nil
    }
}

extension DiscoverListItem {
//    var anyMediaListController: TMDBMediaListController<AnyMedia> {
//        return TMDBMediaListController<AnyMedia>.customList(title: name, path: path ?? "", query: query ?? "")
//    }
    
//    var movieController: TMDBMediaListController<Movie> {
//        return TMDBMediaListController<Movie>.customList(title: name, path: path ?? "", query: query ?? "")
//    }
//
//    func mediaC<T: Media>() -> TMDBMediaListController<T> {
//        return TMDBMediaListController<T>.customList(title: name, path: path ?? "", query: query ?? "")
//    }
//
//    var anyMediaController: TMDBMediaListController<AnyMedia> {
//        return TMDBMediaListController<TVShow>.customList(title: name, path: path ?? "", query: query ?? "")
//    }
    
//    var mediaController: some MediaListController {
//        return TMDBMediaListController<Movie>.customList(title: name, path: path ?? "", query: query ?? "")
//    }
//
    
    var moviesController: MoviesListController? { return nil }
    
    var mediaController: MediaListController? {
        guard let path = path, let query = query else { return nil }
        switch mediaType {
        case "tv":
            return TMDBMediaListController<TVShow>.customList(title: name, path: path, query: query)
        default:
            return TMDBMediaListController<Movie>.customList(title: name, path: path, query: query)
        }
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
