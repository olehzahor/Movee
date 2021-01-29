//
//  SearchViewController.swift
//  Movee
//
//  Created by jjurlits on 1/4/21.
//

import UIKit

class SearchViewController: UITableViewController, Coordinated {
    var coordinator: SearchCoordinator?
    var discoverController: DiscoverController? {
        didSet {
            guard let discoverController = discoverController else { return }
            isSearchBarVisible = !discoverController.isNested
            isTopSectionVisible = !discoverController.isNested
            if discoverController.isNested {
                navigationItem.largeTitleDisplayMode = .never
            }
        }
    }
    
    var searchHistoryController = SearchHistoryController()
    
    var isSearchBarVisible = true
    var isTopSectionVisible = true
    
    private var searchController: UISearchController!
    private var resultsController: MoviesListViewController!
    
    private lazy var topSectionItems: KeyValuePairs =
        ["Advanced Search": { self.coordinator?.showAdvancedSearch() },
         "Search History": { self.coordinator?.showSearchHistory(controller: self.searchHistoryController)}]
    
    fileprivate func setupSearchController() {
        resultsController = MoviesListViewController()
        resultsController.coordinator = self.coordinator
        
        resultsController.searchHistoryController = searchHistoryController
        resultsController.trackHistory = true
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
    }

    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = discoverController?.name ?? "Search"
        
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        if isSearchBarVisible {
            setupSearchController()
        }
    }
}

extension SearchViewController {
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
            cell.textLabel?.text = topSectionItems[indexPath.row].key
        } else {
            let list = discoverController?.lists[indexPath.row]
            cell.textLabel?.text = list?.name
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell

    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0, isTopSectionVisible {
            topSectionItems[indexPath.row].value()
        } else {
            guard let list = discoverController?.lists[indexPath.row] else { return }
            if let controller = list.moviesController {
                coordinator?.showCustomMoviesList(moviesController: controller)
            } else {
                coordinator?.showNestedDiscoverList(discoverController: discoverController?.moved(to: list))
            }
        }
    }
}

extension SearchViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let resultsController = searchController.searchResultsController as? MoviesListViewController
        
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty
        else { return }
        
        let searchController = TMDBMoviesListController.searchResults(query: searchText)
        resultsController?.loadFromController(searchController)
//        resultsController?.setMoviesController(controller)
//        controller.load(completion: controller.update(with:))
    }
}
