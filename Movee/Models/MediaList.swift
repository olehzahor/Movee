//
//  MediaList.swift
//  Movee
//
//  Created by jjurlits on 3/2/21.
//

import Foundation

struct MediaPagedResult<T: Media>: Hashable, Codable {
    var results: [T]
    var total_results: Int
    var total_pages: Int
    var page: Int
}

struct MediaContainer<T: Media>: Hashable {
    var id: Int
    var index: Int?
    var page: Int?
    var media: T?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct MediaList<T: Media> {
    internal var items = [MediaContainer<T>]()
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
    
    private subscript(index: Int) -> MediaContainer<T>? {
        return items.first(where: { $0.index == index })
    }
    
    private var count: Int {
        return loaded
    }
    
    private func contains(id: Int) -> Bool {
        return items.contains(where: { $0.id == id })
    }
    
    private func contains(index: Int) -> Bool {
        return items.contains(where: { $0.index == index })
    }
    
    var isOnLastPage: Bool {
        return total == loaded
    }
    
    //TODO: update existing page
    mutating func update(with pagedResult: MediaPagedResult<T>) {
        let page = pagedResult.page
        
        if loadedPages.contains(page) { return }
        
        loadedPages.append(page)
        lastLoadedPage = page
        total = pagedResult.total_results
        pages = pagedResult.total_pages
        
        for media in pagedResult.results {
            guard let mediaId = media.id,
                  !items.contains(where: { $0.id == mediaId })
            else { continue }
            
            let container = MediaContainer(
                id: mediaId, index: newItemIndex, page: page, media: media)
            
            items.append(container)
            newItemIndex += 1
        }
    }
}

