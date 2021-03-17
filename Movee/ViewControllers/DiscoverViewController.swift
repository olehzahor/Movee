//
//  SearchViewController.swift
//  Movee
//
//  Created by jjurlits on 1/4/21.
//

import UIKit

private extension DiscoverViewController {
    struct TopSectionItem {
        var title: String
        var action: () -> Void
    }
    
    var topSectionItems: [TopSectionItem] {
        let advancedMoviesSearchItem =
            TopSectionItem(title: "Advanced Movies Search",
                           action: { self.coordinator?.showMoviesAdvancedSearch() })
        let advancedTVShowsSearchItem =
            TopSectionItem(title: "Advanced TV Shows Search",
                           action: { self.coordinator?.showTVShowsAdvancedSearch() })

        var items = [advancedMoviesSearchItem, advancedTVShowsSearchItem]
        
        if searchHistoryController.count > 0 {
            let searchHistoryItem = TopSectionItem(
                title: "Search History",
                action: {
                    self.coordinator?.showSearchHistory(
                        controller: self.searchHistoryController) })
            items += [searchHistoryItem]
        }
        return items
    }
}

class DiscoverViewController: UITableViewController, Coordinated {
    var coordinator: SearchCoordinator?
    var discoverController: DiscoverController? {
        didSet {
            guard let discoverController = discoverController else { return }
            isSearchBarVisible = !discoverController.isNested
            isTopSectionVisible = !discoverController.isNested
            if discoverController.isNested {
                navigationItem.largeTitleDisplayMode = .never
            }
            discoverController.loadData(completion: update)
        }
    }
    
    var searchHistoryController = SearchHistoryController.shared
    
    var isSearchBarVisible = true
    var isTopSectionVisible = true
    
    private var searchController: UISearchController?
    private var resultsController: MediaListViewController?
    
    func setupSearchHistoryController() {
        if searchHistoryController.dataState == .notLoaded {
            searchHistoryController.loadData { self.update() }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.update), name: SearchHistoryController.ncUpdatedName, object: nil)
    }

        
    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = discoverController?.name ?? "Search"
        
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        setupSearchHistoryController()
        
        if isSearchBarVisible {
            setupSearchController()
        }
    }
}

extension DiscoverViewController {
    @objc private func update() {
        if isViewLoaded { tableView.reloadData() }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 0
        
        if discoverController != nil { numberOfSections += 1 }
        if isTopSectionVisible { numberOfSections += 1 }
        
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Discover" : nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0, isTopSectionVisible {
            return topSectionItems.count
        } else { return discoverController?.lists.count ?? 0 }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        else { fatalError() }

        if indexPath.section == 0, isTopSectionVisible {
            cell.textLabel?.text = topSectionItems[indexPath.row].title
        } else {
            let list = discoverController?.lists[indexPath.row]
            cell.textLabel?.text = list?.name
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell

    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, isTopSectionVisible {
            topSectionItems[indexPath.row].action()
        } else {
            guard let list = discoverController?.lists[indexPath.row] else { return }
            if let controller = list.mediaController {
                coordinator?.showCustomMediaList(mediaController: controller)
            } else {
                coordinator?.showNestedDiscoverList(discoverController: discoverController?.moved(to: list))
            }
        }
    }
}

extension DiscoverViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
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
        searchController?.searchBar.placeholder = "Movies, TV Shows and People"
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


