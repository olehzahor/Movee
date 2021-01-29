//
//  ExploreController.swift
//  Movee
//
//  Created by jjurlits on 12/11/20.
//

import Foundation

class DiscoverController {
    private(set) var lists = [DiscoverListItem]()
    private(set) var isNested = false
    private(set) var name: String?
    
    func moved(to list: DiscoverListItem) -> DiscoverController? {
        return DiscoverController(lists: list.nestedLists, isNested: true, name: list.name)
    }
    
    init(lists: [DiscoverListItem], isNested: Bool = false, name: String? = nil) {
        self.lists = lists
        self.isNested = isNested
        self.name = name
    }
}
