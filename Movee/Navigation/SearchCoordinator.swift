//
//  SearchCoordinator.swift
//  Movee
//
//  Created by jjurlits on 12/10/20.
//

import Foundation
import FirebaseDatabase

class SearchCoordinator: MainCoordinator {
    func showSearchHistory(controller: SearchHistoryController) {
        createAndPush(SearchHistoryViewController.self) {
            $0.setMediaController(controller)
        }
    }
    
    override func start() {
        let vc = DiscoverViewController()
        vc.coordinator = self
        let database = Database.database().reference()
        vc.discoverController = RemoteDiscoverController(database: database, path: "discoverLists")
        vc.tabBarItem = .init(tabBarSystemItem: .search, tag: 2)
        navigationController.pushViewController(vc, animated: false)
    }
}
