//
//  HomeViewController.swift
//  Movee
//
//  Created by jjurlits on 1/11/21.
//

import UIKit

class HomeViewController: UIViewController, Coordinated {
    typealias DataSource = UICollectionViewDiffableDataSource<String, MediaContainer>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, MediaContainer>
    
    private lazy var dataSource = createDataSource()
    private var snapshot = Snapshot()
    
    weak var coordinator: MainCoordinator?
    var collectionView: UICollectionView!
    
    var discoverController = DiscoverController(lists: Bundle.main.decode(from: "home"))
    var watchlistController: WatchlistController?
    
        
    var mediaControllers: [AnyMediaListController] = []
    
    private var watchlistSection: String? {
        return watchlistController?.title
    }
    
    @objc func updateWatchlist() {
        guard let controller = watchlistController else { return }
        controller.load {
            self.update(with: controller)
        }
    }
    
    fileprivate func setupCollectionView() {
        collectionView = createCollectionView(layout: createLayout())
        
        collectionView.delegate = self
        collectionView.contentInset.top = 10
        
        collectionView.registerCell(CompactMovieCell.self)
        collectionView.registerHeader(SectionHeader.self)
    }
    
    fileprivate func addObserverForWatchlistUpdates() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateWatchlist), name: WatchlistController.ncUpdatedName, object: nil)
    }
    
    fileprivate func loadWatchList(completion: (() -> Void)? = nil) {
        guard let watchlistController = watchlistController else { return }
        watchlistController.load {
            self.update(with: watchlistController)
            completion?()
        }
    }
    
    fileprivate func loadLists() {
        let group = DispatchGroup()
        
        
        let controllers = discoverController.lists.compactMap({ $0.mediaController })
        for controller in controllers {
            mediaControllers.append(controller)
            group.enter()
            controller.load(fromPage: 1, infiniteScroll: false) {
                group.leave()
            }
        }
                
        group.notify(queue: .main) {
            for controller in self.mediaControllers {
                self.updateSnapshot(from: controller)
            }
            self.dataSource.apply(self.snapshot)
        }
    }
    
    fileprivate func manageMoviesControllers() {
        if watchlistController != nil {
            loadWatchList() {
                self.loadLists()
            }
        } else {
            loadLists()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        addObserverForWatchlistUpdates()
        manageMoviesControllers()
        
        title = "Explore"
    }
    
}

extension HomeViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            return GenericLayouts.createHorizontalListSection(height: 187, width: 110, addHeader: true)
        }
    }
}

//MARK: - Navigation
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let media = dataSource.itemIdentifier(for: indexPath)?.media else { return }
        if let movie = media as? Movie {
            coordinator?.showDetails(movie: movie)
        } else if let tvShow = media as? TVShow {
            coordinator?.showDetails(tvShow: tvShow)
        }
    }

    func seeAllMoviesInList(listTitle: String?) {
        guard let listTitle = listTitle else { return }
        if let list = discoverController.lists.first(
            where: { $0.name == listTitle }) {
            coordinator?.showCustomMediaList(mediaController: list.mediaController)
        }

    }
}

//MARK: - Data Source
extension HomeViewController {
    struct MediaContainer: Hashable {
        let media: AnyHashable
        let list: String

        static func createContainers(from medias: [AnyHashable], listName: String) -> [MediaContainer] {
            medias.compactMap { media in
                return MediaContainer(media: media, list: listName)
            }
        }
    }

    func updateDataSource() {
        dataSource.apply(snapshot)
    }
    
    func update(with controller: AnyMediaListController) {
        dataSource.apply(updateSnapshot(from: controller))
    }
    
    @discardableResult
    func updateSnapshot(from controller: AnyMediaListController) -> Snapshot {
        let section = controller.title
        
        if controller.medias.count == 0 {
            if snapshot.sectionIdentifiers.contains(section) {
                snapshot.deleteSections([section])
            }
            return snapshot
        }
        
        if snapshot.sectionIdentifiers.contains(section) {
            snapshot.deleteItems(snapshot.itemIdentifiers(inSection: section))
        } else {
            if section == watchlistSection, let firstSection = snapshot.sectionIdentifiers.first {
                snapshot.insertSections([section], beforeSection: firstSection)
            } else {
                snapshot.appendSections([section])
            }
        }
        
        let containers = MediaContainer.createContainers(
            from: controller.medias, listName: controller.title)
            
        snapshot.appendItems(containers, toSection: section)
        return snapshot
    }
    
    func createDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, container) -> UICollectionViewCell? in
                let media = container.media
                let cell = collectionView.dequeueCell(CompactMovieCell.self, for: indexPath)
                if let movie = media as? Movie {
                    movie.viewModel.configure(cell)
                } else if let tvShow = media as? TVShow {
                    tvShow.viewModel.configure(cell)
                }
                return cell
            })
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            
            guard let sectionTitle = dataSource.findSection(at: indexPath) else { return nil }
            
            let header = collectionView.dequeueHeader(SectionHeader.self, for: indexPath)
            header.titleLabel.text = sectionTitle
            
            if sectionTitle == self.watchlistController?.title {
                header.titleLabel.text! += ": Up Next"
                return header
            }
            
            header.setAction(title: "See All") {
                self.seeAllMoviesInList(listTitle: sectionTitle)
            }
            return header
        }
        return dataSource
    }
}
