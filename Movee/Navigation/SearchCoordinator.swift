//
//  SearchCoordinator.swift
//  Movee
//
//  Created by jjurlits on 12/10/20.
//

import Foundation

class SearchCoordinator: MainCoordinator {
    func showSearchHistory(controller: SearchHistoryController) {
        createAndPush(MoviesListViewController.self) {
            $0.setMoviesController(controller)
        }
    }
    
    override func start() {
        createAndPush(SearchViewController.self) { vc in
            DispatchQueue.global(qos: .background).async {
                let lists: [DiscoverListItem] = Bundle.main.decode(from: "lists")
                DispatchQueue.main.async {
                    vc.discoverController = DiscoverController(
                        lists: lists)
                }
            }
            vc.tabBarItem = .init(tabBarSystemItem: .search, tag: 2)
        }
    }
}
