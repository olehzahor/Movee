//
//  WatchlistCoordinator.swift
//  Movee
//
//  Created by jjurlits on 12/10/20.
//

import UIKit

class WatchlistCoordinator: MainCoordinator {
    private var watchlistTabBarItem: UITabBarItem?

    override func start() {
        createAndPush(WatchlistViewController.self, animated: false) {
            $0.tabBarItem = .init(title: NSLocalizedString("Watchlist", comment: ""), image: UIImage(systemName: "list.and.film"), tag: 1)
            $0.setupBadge()
        }
    }
}
