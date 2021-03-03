////
////  HomeViewController.swift
////  Movee
////
////  Created by jjurlits on 1/11/21.
////
//
//import UIKit
//
//class HomeViewController: UIViewController, GenericCollectionViewController, Coordinated {
//    typealias DataSource = UICollectionViewDiffableDataSource<String, MovieContainer>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<String, MovieContainer>
//    
//    private lazy var dataSource = createDataSource()
//    private var snapshot = Snapshot()
//    
//    weak var coordinator: MainCoordinator?
//    var collectionView: UICollectionView!
//    
//    var discoverController = DiscoverController(lists: Bundle.main.decode(from: "home"))
//    var watchlistController: WatchlistController?
//        
//    var moviesControllers: [MoviesListController] = []
//    
//    private var watchlistSection: String? {
//        return watchlistController?.title
//    }
//    
//    @objc func updateWatchlist() {
//        watchlistController?.load(completion: update(with:))
//    }
//    
//    fileprivate func setupCollectionView() {
//        collectionView = createCollectionView()
//        
//        collectionView.delegate = self
//        collectionView.contentInset.top = 10
//        
//        registerCell(CompactMovieCell.self)
//        registerHeader(SectionHeader.self)
//    }
//    
//    fileprivate func addObserverForWatchlistUpdates() {
//        NotificationCenter.default.addObserver(self, selector: #selector(self.updateWatchlist), name: WatchlistController.ncUpdateName, object: nil)
//    }
//    
//    fileprivate func loadWatchList(completion: (() -> Void)? = nil) {
//        guard let watchlistController = watchlistController else { return }
//        watchlistController.load { controller in
//            self.update(with: controller)
//            completion?()
//        }
//    }
//    
//    fileprivate func loadLists() {
//        let group = DispatchGroup()
//        
//        let controllers = discoverController.lists.compactMap({$0.moviesController})
//        for controller in controllers {
//            moviesControllers.append(controller)
//            group.enter()
//            controller.load() { _ in group.leave() }
//        }
//                
//        group.notify(queue: .main) {
//            for controller in self.moviesControllers {
//                self.updateSnapshot(from: controller)
//            }
//            self.dataSource.apply(self.snapshot)
//        }
//
//    }
//    
//    fileprivate func manageMoviesControllers() {
//        if watchlistController != nil, watchlistController!.count > 0 {
//            loadWatchList() {
//                self.loadLists()
//            }
//        } else {
//            loadLists()
//        }
//
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupCollectionView()
//        addObserverForWatchlistUpdates()
//        manageMoviesControllers()
//        
//        title = "Explore"
//    }
//    
//}
//
//extension HomeViewController {
//    func createLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            return GenericLayouts.createHorizontalListSection(height: 187, width: 110, addHeader: true)
//        }
//    }
//}
//
//extension HomeViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard let container = dataSource.itemIdentifier(for: indexPath) else { return }
//        if container.movie == Movie.placeholder {
//            let sectionTitle = findSection(at: indexPath, in: self.dataSource)
//            seeAllMoviesInList(listTitle: sectionTitle)
//        } else {
//            coordinator?.showDetails(movie: container.movie)
//        }
//    }
//}
//
//extension HomeViewController {
//    struct MovieContainer: Hashable {
//        let movie: Movie
//        let list: String
//        
//        static func createContainers(from movies: [Movie], listName: String, removePlaceholder: Bool = true) -> [MovieContainer] {
//            movies.compactMap { movie in
//                if movie == Movie.placeholder, removePlaceholder { return nil }
//                return MovieContainer(movie: movie, list: listName)
//            }
//        }
//    }
//    
//    func updateDataSource() {
//        dataSource.apply(snapshot)
//    }
//    
//    func update(with controller: MoviesListController) {
//        dataSource.apply(updateSnapshot(from: controller), animatingDifferences: true)
//    }
//    
//    @discardableResult
//    func updateSnapshot(from controller: MoviesListController) -> Snapshot {
//        let section = controller.title
//        
//        if controller.movies.count == 0 {
//            if snapshot.sectionIdentifiers.contains(section) {
//                snapshot.deleteSections([section])
//            }
//            return snapshot
//        }
//        
//        if snapshot.sectionIdentifiers.contains(section) {
//            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
//        } else {
//            if section == watchlistSection, let firstSection = snapshot.sectionIdentifiers.first {
//                snapshot.insertSections([section], beforeSection: firstSection)
//            } else {
//                snapshot.appendSections([section])
//            }
//        }
//        
//        var items = MovieContainer.createContainers(from: controller.movies, listName: controller.title)
//        if section != watchlistSection { items.shuffle() }
//        
//        snapshot.appendItems(items, toSection: section)
//        return snapshot
//    }
//
//    
//    func seeAllMoviesInList(listTitle: String?) {
//        guard let listTitle = listTitle else { return }
//        if let list = discoverController.lists.first(
//            where: { $0.name == listTitle }),
//           let controller = list.moviesController {
//            coordinator?.showCustomMoviesList(moviesController: controller)
//        }
//    }
//    
//    func createDataSource() -> DataSource {
//        let dataSource = DataSource(
//            collectionView: collectionView,
//            cellProvider: { [self] (collectionView, indexPath, container) -> UICollectionViewCell? in
//                let cell = dequeueCell(CompactMovieCell.self, for: indexPath)
//                container.movie.viewModel.configure(cell)
//                return cell
//            })
//        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
//            
//            guard let sectionTitle = self.findSection(at: indexPath, in: self.dataSource) else { return nil }
//            let header = self.dequeueHeader(SectionHeader.self, for: indexPath)
//            header.titleLabel.text = sectionTitle
//            
//            if sectionTitle == self.watchlistController?.title {
//                header.titleLabel.text! += ": Up Next"
//                return header
//            }
//            
//            header.setAction(title: "See All") {
//                self.seeAllMoviesInList(listTitle: sectionTitle)
//            }
//            return header
//        }
//        return dataSource
//    }
//}
