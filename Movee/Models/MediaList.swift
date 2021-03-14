protocol MediaListItem: Hashable, Codable, Identifiable {
    static var placeholder: Self { get }
}

struct MediaListItemContainer<T: MediaListItem>: Hashable {
    var id: T.ID
    var index: Int?
    var page: Int?
    var media: T?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


struct MediaList<T: MediaListItem> {
    internal var items = [MediaListItemContainer<T>]()
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
    
    private subscript(index: Int) -> MediaListItemContainer<T>? {
        return items.first(where: { $0.index == index })
    }
    
    private var count: Int {
        return loaded
    }
    
    private func contains(id: T.ID) -> Bool {
        return items.contains(where: { $0.id == id })
    }
    
    private func contains(index: Int) -> Bool {
        return items.contains(where: { $0.index == index })
    }
    
    var isOnLastPage: Bool {
        return total == loaded
    }
    
    //TODO: update existing page
    mutating func update(with pagedResult: PagedResult<T>) {
        let page = pagedResult.page
        
        if loadedPages.contains(page) { return }
        
        loadedPages.append(page)
        lastLoadedPage = page
        total = pagedResult.total_results
        pages = pagedResult.total_pages
        
        for media in pagedResult.results {
            if self.contains(id: media.id) { continue }
            
            let container = MediaListItemContainer(
                id: media.id, index: newItemIndex, page: page, media: media)
            
            items.append(container)
            newItemIndex += 1
        }
    }
}
