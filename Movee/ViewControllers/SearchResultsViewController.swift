//
//  PeopleViewController.swift
//  Movee
//
//  Created by jjurlits on 2/17/21.
//

import UIKit


extension SearchResult {
    var mediaContainer: AnyHashable? {
        switch self {
        case .character(let character):
            return character
        case .tv(let tvShow):
            return tvShow
        case .movie(let movie):
            return movie
        case .empty:
            return SearchResult.placeholder
        }
    }
}

class MSRController: AnyMediaListController<SearchResult> {
    override var medias: [AnyHashable] {
        guard let medias = super.medias as? [SearchResult] else { return [] }
        return medias.compactMap { $0.mediaContainer }
    }
    
    static func multiSearchResult(query: String) -> Self {
        return .init { (page, completion) -> URLSessionTask? in
            TMDBClient.shared.searchMulti(query: query, page: page, completion: completion)
        }
    }

}


class SearchResultsViewController2: UIViewController, GenericCollectionViewController, Coordinated {
    enum Section {
        case main
    }
    
    struct ResultWrapper: Hashable {
        var item: AnyHashable
    }

    var collectionView: UICollectionView!
    var searchResultsController: AnyMediaListControllerProtocol!
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            let sectionLayout = GenericLayouts.createFullWidthSection(height: 150, addHeader: false)
            sectionLayout?.interGroupSpacing = 16
            return sectionLayout
        }
    }
    
    var coordinator: SearchCoordinator?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ResultWrapper>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ResultWrapper>
    private lazy var dataSource = createDataSource()
    
    fileprivate func configureCollectionView() {
        collectionView = createCollectionView()
        collectionView.contentInset.top = 16
        
        //collectionView.delegate = self
        
        registerCell(CharacterSearchCell.self)
        registerCell(MovieCell.self)
        registerCell(PlaceholderCell.self)
    }
    
    func loadFromController(_ controller: AnyMediaListControllerProtocol) {
        self.searchResultsController = controller
        controller.load(completion: update)
    }
    
    override func viewDidLoad() {
        configureCollectionView()
    }
    
    var oldItems = [AnyHashable]()
}

extension SearchResultsViewController2 {
    func update() {
        if let searchResultsController = searchResultsController {
            dataSource.apply(createSnapshot(from: searchResultsController))
        }
    }
        
    func createSnapshot(from controller: AnyMediaListControllerProtocol) -> Snapshot {
        oldItems = dataSource.snapshot().itemIdentifiers
        
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        let wrappedItems = controller.medias.compactMap { ResultWrapper(item: $0) }
        snapshot.appendItems(wrappedItems, toSection: .main)
        return snapshot
    }
    
    func createDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { (collectionView, indexPath, result) -> UICollectionViewCell? in
            
            if let character = result.item as? Character {
                let cell = self.dequeueCell(CharacterSearchCell.self, for: indexPath)
                character.viewModel.configure(cell)
                return cell
            } else if let movie = result.item as? Movie {
                let cell = self.dequeueCell(MovieCell.self, for: indexPath)
                movie.viewModel.configure(cell)
                print(movie.hashValue)
                return cell
            } else if let tvShow = result.item as? TVShow {
                let cell = self.dequeueCell(MovieCell.self, for: indexPath)
                tvShow.viewModel.configure(cell)
                return cell
            } else {
                self.searchResultsController.loadMore(completion: self.update)
                return self.dequeueCell(PlaceholderCell.self, for: indexPath)
            }
        }
    }
}


class SearchResultsViewController: UIViewController, GenericCollectionViewController, Coordinated {
    var coordinator: SearchCoordinator?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, SearchResult>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SearchResult>
    private lazy var dataSource = createDataSource()
    
    var collectionView: UICollectionView!
    
    var searchController: SearchResultsController?
    
    //TODO: move search history to search controller
    var searchHistoryController: SearchHistoryController?

    
    fileprivate func configureCollectionView() {
        collectionView = createCollectionView()
        collectionView.contentInset.top = 16
        
        collectionView.delegate = self
        
        registerCell(CharacterSearchCell.self)
        registerCell(MovieCell.self)
        registerCell(PlaceholderCell.self)
    }
    
    override func viewDidLoad() {
        configureCollectionView()
    }
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            let sectionLayout = GenericLayouts.createFullWidthSection(height: 150, addHeader: false)
            sectionLayout?.interGroupSpacing = 16
            return sectionLayout
        }
    }
    
    func loadFromController() {
        searchController?.load { _ in
            self.update()
        }
    }
}

extension SearchResultsViewController {
    func update() {
        if let searchController = searchController {
            dataSource.apply(createSnapshot(from: searchController))
        }
    }
        
    func createSnapshot(from controller: SearchResultsController) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(controller.resutls, toSection: .main)
        return snapshot
    }
    
    func createDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { (collectionView, indexPath, result) -> UICollectionViewCell? in
            switch result {
            case .character(let character):
                let cell = self.dequeueCell(CharacterSearchCell.self, for: indexPath)
                character.viewModel.configure(cell)
                return cell
            case .movie(let movie):
                let cell = self.dequeueCell(MovieCell.self, for: indexPath)
                movie.viewModel.configure(cell)
                return cell
            case .tv(let tv):
                let cell = self.dequeueCell(MovieCell.self, for: indexPath)
                tv.viewModel.configure(cell)
                return cell
            case .empty:
                self.searchController?.loadMore { _ in self.update() }
                return self.dequeueCell(PlaceholderCell.self, for: indexPath)
            }
        }
    }
}

extension SearchResultsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .character(let character):
            coordinator?.showPersonInfo(character: character)
        case .movie(let movie):
            coordinator?.showDetails(movie: movie)
            //let vc =  // MediaDetailsViewController()
//            let mediaController = MovieController3(movie)
//            let vc = MediaDetailsViewController(mediaController)
//            coordinator?.navigationController.pushViewController(vc, animated: true)
        case .tv(let tvShow):
            coordinator?.showDetails(tvShow: tvShow)
//            let mediaController = TVShowController3(tvShow)
//            let vc = MediaDetailsViewController(mediaController)
//            vc.coordinator = self.coordinator
//            coordinator?.navigationController.pushViewController(vc, animated: true)
        default:
            return
        }
        
    }
}

extension SearchResultsViewController {
    enum Section {
        case main
    }
}
