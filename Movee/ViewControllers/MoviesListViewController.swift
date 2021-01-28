//
//  ModernMoviesController.swift
//  Movee
//
//  Created by jjurlits on 11/17/20.
//

import UIKit

class MoviesListViewController: UIViewController, GenericCollectionViewController, Coordinated {    
    weak var coordinator: MainCoordinator?
    
    var trackHistory: Bool = false
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    private lazy var dataSource = createDataSource()

    var collectionView: UICollectionView!
    private(set) var moviesController: MoviesListController?
    
    var searchHistoryController: SearchHistoryController?

    func setMoviesController(_ moviesController: MoviesListController) {
        self.moviesController = moviesController
    }
    
    func loadFromController(_ moviesController: MoviesListController) {
        setMoviesController(moviesController)
        moviesController.load(completion: update(with:))
    }
    
    fileprivate func loadFromMoviesController() {
        moviesController?.load(completion: update(with:))
    }
    
    fileprivate func setupCollectionView() {
        collectionView = createCollectionView()
        collectionView.contentInset.top = 8
        collectionView.delegate = self
        
        registerCell(MovieCell.self)
        registerCell(PlaceholderCell.self)
    }

    
    fileprivate func setupNavigationItem() {
        title = moviesController?.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationItem()
        
        loadFromMoviesController()
    }
        
    convenience init(moviesController: MoviesListController) {
        self.init()
        setMoviesController(moviesController)
    }
    
    convenience init(title: String, fetchRequest: @escaping MoviesListController.FetchRequest) {
        self.init()
        let controller = TMDBMoviesListController(
            title: title, fetchRequest: fetchRequest)
        setMoviesController(controller)
    }
}

//MARK:- Navigation
extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) else { return }
        if trackHistory { searchHistoryController?.addMovie(movie) }
        coordinator?.showDetails(movie: movie)
    }
}

//MARK:- Data Source
internal extension MoviesListViewController {
    func update(with controller: MoviesListController) {
        dataSource.apply(createSnapshot(from: controller))
    }
    
    func createSnapshot(from controller: MoviesListController) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(controller.movies)
        return snapshot
    }
    
    func createDataSource() -> DataSource {
        return DataSource(
            collectionView: collectionView,
            cellProvider: { [self] (collectionView, indexPath, movie) -> UICollectionViewCell? in
                if movie == Movie.placeholder {
                    let cell = dequeueCell(PlaceholderCell.self, for: indexPath)
                    self.moviesController?.loadMore(completion: update(with:))
                    return cell
                }
                let cell = dequeueCell(MovieCell.self, for: indexPath)
                movie.viewModel.configure(cell)
                return cell
            })
    }
}

extension MoviesListViewController {
    enum Section {
        case main
    }
}
