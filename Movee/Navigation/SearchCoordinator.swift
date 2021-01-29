//
//  SearchCoordinator.swift
//  Movee
//
//  Created by jjurlits on 12/10/20.
//

import Foundation

class SearchCoordinator: MainCoordinator {
    func showNestedExploreList(_ controller: DiscoverController) {
//        createAndPush(DiscoverViewController.self) {
//            $0.discoverController = controller
//        }
    }
    
//    func showAdvancedSearch() {
//        createAndPush(FiltersViewController.self) {
//            $0.coordinator = self
//        }
//    }
    
    func showSearchHistory(controller: SearchHistoryController) {
        createAndPush(MoviesListViewController.self) {
            $0.setMoviesController(controller)
        }
    }
    
    override func start() {
        createAndPush(SearchViewController.self) { vc in
            DispatchQueue.global(qos: .background).async {
                let lists: [DiscoverListItem] = Bundle.main.decode(from: "lists")
                //sleep(5)
                DispatchQueue.main.async {
                    vc.discoverController = DiscoverController(
                        lists: lists)
                }
            }
            vc.tabBarItem = .init(tabBarSystemItem: .search, tag: 2)
        }
//        createAndPush(DiscoverViewController.self, animated: false) {
//            $0.tabBarItem = .init(title: "Explore", image: nil, tag: 2)
//        }
//        createAndPush(MoviesViewController.self, animated: false) {
//            $0.listType = .search("")
//            $0.tabBarItem = .init(tabBarSystemItem: .search, tag: 2)
//        }
    }
}
