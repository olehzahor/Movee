//
//  PeopleViewController.swift
//  Movee
//
//  Created by jjurlits on 2/17/21.
//

import UIKit

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
                tv.transformToMovie().viewModel.configure(cell)
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
            searchHistoryController?.addMovie(movie)
            coordinator?.showDetails(movie: movie)
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
