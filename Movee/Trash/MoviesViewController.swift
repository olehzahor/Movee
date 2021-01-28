////
////  ModernMoviesController.swift
////  Movee
////
////  Created by jjurlits on 11/17/20.
////
//
//import UIKit
//
//class MoviesViewController: UIViewController, GenericCollectionViewController, Coordinated {
//    weak var coordinator: MainCoordinator?
//    
//    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
//    
//    var collectionView: UICollectionView!
//
//    var listType: MoviesListController.ListType? = .popular
//    private(set) var moviesController: MoviesListController!
//
//    private lazy var dataSource = createDataSource()
//    
//    override func viewDidLoad() {
//        guard let listType = listType else {
//            fatalError("List type didn't set for controller.")
//        }
//        
//        switch listType {
//        case .watchlist:
//            tabBarItem.badgeValue = "2"
//        default:
//            break
//        }
//
//        super.viewDidLoad()
//        
//        setupCollectionView()
//        
//        //setupSearchController()
//        setupNavigationItem()
//        
//        setupMoviesController(listType)
//                
//        navigationItem.largeTitleDisplayMode = .always
//        title = listType.title
//    }
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
////        switch listType {
////        case .watchlist:
//////            if WatchlistController.shared.shouldUpdate {
//////                moviesController.reload()
//////            }
////        default:
////            break
////        }
//    }
//    
//    private func setupMoviesController(_ listType: MoviesListController.ListType) {
//        moviesController = MoviesListController(
//            type: listType,
//            updateHandler: update(with:))
//        
//        moviesController.load()
//    }
//
//    private func setupSearchController() {
//        let searchController = UISearchController()
//        searchController.searchResultsUpdater = self
//        searchController.obscuresBackgroundDuringPresentation = false
//        navigationItem.searchController = searchController
//        navigationItem.hidesSearchBarWhenScrolling = true
//    }
//    
//    private func setupCollectionView() {
//        collectionView = createCollectionView()
//        collectionView.delegate = self
//        
//        registerCell(MovieCell.self)
//        registerCell(PlaceholderCell.self)
//    }
//
//    
//    fileprivate func setupNavigationItem() {
//        //navigationController?.navigationBar.prefersLargeTitles = true
//        title = "Search"
//    }
//    
//    func search(query: String) {
//        moviesController.changeListType(to: .search(query), savePrevious: true)
//        moviesController.load()
//    }
//    
//    func returnToList() {
//        moviesController.changeListType(to: .popular)
//        moviesController.loadSavedState()
//    }
//    
//    convenience init(listType: MoviesListController.ListType) {
//        self.init()
//        self.listType = listType
//    }
//}
//
//extension MoviesViewController {
//    enum Section {
//        case main
//    }
//}
//
//extension MoviesViewController: UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        let query = searchController.searchBar.text ?? ""
//        
//        if !query.isEmpty {
//            search(query: query)
//        } else {
//            returnToList()
//        }
//    }
//}
//
//private extension MoviesViewController {
//    func update(with controller: MoviesListController) {
//        dataSource.apply(createSnapshot(from: controller))
//    }
//    
//    func createSnapshot(from controller: MoviesListController) -> Snapshot {
//        var snapshot = Snapshot()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(controller.movies)
//        //print(snapshot.itemIdentifiers.compactMap({ $0.id }))
//        return snapshot
//    }
//    
//    func createDataSource() -> DataSource {
//        return DataSource(
//            collectionView: collectionView,
//            cellProvider: { [self] (collectionView, indexPath, movie) -> UICollectionViewCell? in
//                if movie == Movie.placeholder {
//                    let cell = dequeueCell(PlaceholderCell.self, for: indexPath)
//                    self.moviesController.loadMore()
//                    return cell
//                }
//                let cell = dequeueCell(MovieCell.self, for: indexPath)
//                movie.viewModel.configure(cell)
//                return cell
//            })
//    }
//}
//
//extension MoviesViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
//        coordinator?.showDetails(movie: movie)
//    }
//}
