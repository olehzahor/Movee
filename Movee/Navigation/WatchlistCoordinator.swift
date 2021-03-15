//
//  WatchlistCoordinator.swift
//  Movee
//
//  Created by jjurlits on 12/10/20.
//

import UIKit

class WatchlistCoordinator: MainCoordinator {
//    func watchlistController(_ watchlistController: WatchlistController, countDidChange count: Int) {
//        watchlistTabBarItem?.badgeValue = String(count)
//    }
    
    private var watchlistTabBarItem: UITabBarItem?
    
//    @objc func updateWatchlistCount() {
//        let watchlistCount = WatchlistController.shared.list().count
//        
//        if watchlistCount > 0 {
//            self.watchlistTabBarItem?.badgeValue = String(watchlistCount)
//        } else { self.watchlistTabBarItem?.badgeValue = nil }
//    }
//    
    
    override func start() {
        createAndPush(WatchlistViewController.self, animated: false) {
            //$0.watchlistController = self.watchlistController
            $0.tabBarItem = .init(title: "Watchlist", image: UIImage(systemName: "list.and.film"), tag: 1)
            $0.setupBadge()


        }
    }
}
