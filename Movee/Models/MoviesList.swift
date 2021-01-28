//
//  MoviesList.swift
//  Movee
//
//  Created by jjurlits on 1/4/21.
//

import Foundation

internal struct MoviesList {
    internal var items = [MovieContainer]()
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
    
    private subscript(index: Int) -> MovieContainer? {
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
    mutating func update(with pagedResult: MoviesPagedResult) {
        let page = pagedResult.page
        
        if loadedPages.contains(page) { return }
        
        loadedPages.append(page)
        lastLoadedPage = page
        total = pagedResult.total_results
        pages = pagedResult.total_pages
        
        for movie in pagedResult.results {
            guard let movieId = movie.id,
                  !items.contains(where: { $0.id == movieId })
            else { continue }
            
            let container = MovieContainer(
                id: movieId, index: newItemIndex, page: page, movie: movie
            )
            
            items.append(container)
            newItemIndex += 1
        }
    }
}
