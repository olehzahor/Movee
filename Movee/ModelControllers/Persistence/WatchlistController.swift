//
//  WatchlistController.swift
//  Movee
//
//  Created by jjurlits on 12/9/20.
//

import Foundation

class WatchlistController: StoredMediaListController {
    static var shared: WatchlistController = WatchlistController()
    
    @objc override var title: String { return NSLocalizedString("Watchlist", comment: "") }
    
    static let ncUpdatedName = Notification.Name("WatchlistUpdated")
    static let ncLoadedName = Notification.Name("WatchlistLoaded")
    
    override internal func postUpdated() {
        NotificationCenter.default.post(name: Self.ncUpdatedName, object: nil)
    }

    override internal func postLoaded() {
        NotificationCenter.default.post(name: Self.ncLoadedName, object: nil)
    }
    
    private convenience init() {
        self.init(filename: "watchlist.json")
    }
}
