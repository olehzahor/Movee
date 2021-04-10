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
    
    func showSearchHistory() {
        showSearchHistory(controller: SearchHistoryController.shared)
    }

    
    override func start() {
        createAndPush(SearchViewController.self) {
//            $0.discoverController = DiscoverController(fromBundle: "mowee-542f8-default-rtdb-export")
            $0.discoverController = RemoteDiscoverController(
                database: Database.database().reference(), path: "discoverLists")
            $0.tabBarItem = .init(tabBarSystemItem: .search, tag: 2)
        }
//        let vc = DiscoverViewController()
//        vc.coordinator = self
//        let database = Database.database().reference()
//        vc.discoverController = RemoteDiscoverController(database: database, path: "discoverLists")
        //vc.tabBarItem = .init(tabBarSystemItem: .search, tag: 2)
        //navigationController.pushViewController(vc, animated: false)
    }
    
    func showSmartFilters() {
        createAndPush(SmartFiltersViewController.self)
    }
    
    func showMoviesAdvancedSearch() {
        createAndPush(FiltersViewController.self) {
            $0.filterController = MoviesFilterController()
            $0.mediaType = .movie
        }
    }
    
    func showTVShowsAdvancedSearch() {
        createAndPush(FiltersViewController.self) {
            $0.filterController = TVShowsFilterController()
            $0.mediaType = .tvShow
        }
    }

    
    func showFilteredMovies(filter: Filter) {
        createAndPush(MediaListViewController.self) {
            $0.setMediaController(
                MediaListController<Movie>.filteredMovies(filter: filter))
        }
    }
    
    func showFilteredTVShows(filter: Filter) {
        createAndPush(MediaListViewController.self) {
            $0.setMediaController(
                MediaListController<TVShow>.filteredTVShows(filter: filter))
        }
    }

        
    func showNestedDiscoverList(discoverController: DiscoverController?) {
        guard let discoverController = discoverController else { return }
        createAndPush(DiscoverViewController.self) {
            $0.discoverController = discoverController
        }
    }


}
