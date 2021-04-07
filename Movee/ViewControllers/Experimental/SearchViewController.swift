//
//  SearchViewController.swift
//  Movee
//
//  Created by jjurlits on 3/19/21.
//

import UIKit

class SearchViewController: CVDiscoverVC {
    var searchHistoryController = SearchHistoryController.shared
    
    private var searchController: UISearchController?
    private var resultsController: MediaListViewController?
    
    var topSectionItems: [Item] {
        let advancedSearchItem = Item(title: "Advanced Search".l10ed,
                                      action: { _ in self.coordinator?.showSmartFilters() })
        var items = [advancedSearchItem]
        if searchHistoryController.count > 0 {
            let searchHistoryItem = Item(title: "Search History".l10ed,
                                         action: { _ in self.coordinator?.showSearchHistory() })
            items += [searchHistoryItem]
        }
        return items
    }

    
    func setupSearchHistoryController() {
        if searchHistoryController.dataState == .notLoaded {
            searchHistoryController.loadData { self.update() }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.update), name: SearchHistoryController.ncUpdatedName, object: nil)
    }
    
    override func createSnapshot() -> CVDiscoverVC.Snapshot {
        var snapshot = super.createSnapshot()
        let topSection = Section.custom("")
        snapshot.insertSections([topSection], beforeSection: .main)
        snapshot.appendItems(topSectionItems, toSection: topSection)
//
//        snapshot.appendSections([Section.custom("Discover")])
//        snapshot.appendItems(snapshot.itemIdentifiers(inSection: .main), toSection: Section.custom("Discover"))
//        
//        snapshot.deleteSections([.main])
        return snapshot
    }
    
    override func viewDidLoad() {
        setupSearchHistoryController()
        setupSearchController()
        
        super.viewDidLoad()
        title = "Search".l10ed
    }
}

extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    fileprivate func setupSearchController() {
        resultsController = MediaListViewController()
        resultsController?.coordinator = self.coordinator
        
        resultsController?.searchHistoryController = searchHistoryController
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.delegate = self
        
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.autocapitalizationType = .none
        searchController?.searchBar.delegate = self
        searchController?.searchBar.scopeButtonTitles = SearchResultType.titles
        searchController?.searchBar.placeholder = "Movies, TV Shows and People".l10ed
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty
        else { return }

        let resultsController = searchController.searchResultsController as? MediaListViewController
        
        let selectedFilter =
            SearchResultType.allCases[searchController.searchBar.selectedScopeButtonIndex]
        
        let controller = selectedFilter.listController(query: searchText)
        
        resultsController?.loadFromMediaController(controller)
    }
}
