//
//  SearchHistoryController.swift
//  Movee
//
//  Created by jjurlits on 1/24/21.
//

import Foundation

class SearchHistoryController: StoredMediaListController {
    @objc override var title: String { return "Search History" }
    
    static let ncUpdatedName = Notification.Name("SearchHistoryUpdated")
    
    override func postUpdated() {
        NotificationCenter.default.post(name: Self.ncUpdatedName, object: nil)
    }
        
    static var shared: SearchHistoryController = SearchHistoryController()
    
    convenience private init(completion: @escaping () -> Void) {
        self.init()
        loadData(completion: completion)
    }
    
    convenience private init() {
        self.init(filename: "search_history.json")
    }
    
    override private init(filename: String) {
        super.init(filename: filename)
    }
}
