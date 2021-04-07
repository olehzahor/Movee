//
//  SearchViewController.swift
//  Movee
//
//  Created by jjurlits on 1/4/21.
//

import UIKit

class DDSDiscoverViewController: UITableViewController, Coordinated {
    typealias DataSource = DiscoverViewControllerDataSource
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    private lazy var dataSource = createDataSource()
    
    //var tableView: UITableView!

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
    
    fileprivate func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        if self.isBeingPresented || self.isMovingToParent {
//            dataSource.apply(createSnapshot(), animatingDifferences: false)
//        }
    }
            
    override func viewDidLoad() {
        
        setupTableView()
        setupSearchController()
        
        setupSearchHistoryController()
        dataSource.apply(createSnapshot(), animatingDifferences: false)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = discoverController?.name ?? "Search"

        //discoverController?.loadData(completion: update)
    }
}

extension DDSDiscoverViewController {
    private var initialSnapshot: Snapshot {
        var snapshot = Snapshot()
        if isTopSectionVisible, !topSectionItems.isEmpty {
            snapshot.appendSections([.top])
            snapshot.appendItems(topSectionItems)
        }
        snapshot.appendSections([.discover])
        return snapshot
    }
    
    @objc func update() {
        if isViewLoaded { dataSource.apply(createSnapshot()) }
    }
        
    func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        if isTopSectionVisible, !topSectionItems.isEmpty {
            snapshot.appendSections([.top])
            snapshot.appendItems(topSectionItems)
        }
        
        let discoverLists = discoverController?.lists ?? []
        snapshot.appendSections([.discover])
        snapshot.appendItems(discoverLists, toSection: .discover)
        
        return snapshot
    }
    
    func createDataSource() -> DataSource {
        let dataSource = DataSource(tableView: tableView) { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            if let listTitle = (item as? DiscoverListItem)?.name {
                cell.textLabel?.text = listTitle
            } else if let topSectionItem = (item as? TopSectionItem) {
                cell.textLabel?.text = topSectionItem.title
            }
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        dataSource.apply(initialSnapshot, animatingDifferences: false)
        return dataSource
    }

}

extension DDSDiscoverViewController {
    class DiscoverViewControllerDataSource: UITableViewDiffableDataSource<Section, AnyHashable> {
//        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//            if snapshot().numberOfSections < 2 { return "" }
//            return snapshot().sectionIdentifiers[section].rawValue
//        }
    }
    
    enum Section: String { case top = "", discover = "Discover" }

    struct TopSectionItem: Hashable {
        static func == (lhs: DDSDiscoverViewController.TopSectionItem, rhs: DDSDiscoverViewController.TopSectionItem) -> Bool {
            lhs.title == rhs.title
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
        
        var title: String
        var action: () -> Void
    }
    
    var topSectionItems: [TopSectionItem] {
        let advancedSearchItem =
            TopSectionItem(title: "Advanced Search",
                           action: { self.coordinator?.showMoviesAdvancedSearch() })
        var items = [advancedSearchItem]
        
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

extension DDSDiscoverViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource.itemIdentifier(for: indexPath)
        switch dataSource.findSection(at: indexPath) {
        case .top:
            guard let topSectionItem = item as? TopSectionItem else { return }
            topSectionItem.action()
        case .discover:
            guard let list = item as? DiscoverListItem else { return }
            if let controller = list.mediaController {
                coordinator?.showCustomMediaList(mediaController: controller)
            } else {
                coordinator?.showNestedDiscoverList(discoverController: discoverController?.moved(to: list))
            }
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension DDSDiscoverViewController: UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
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


