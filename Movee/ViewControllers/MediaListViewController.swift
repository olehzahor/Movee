//
//  AnyMediaListVC.swift
//  Movee
//
//  Created by jjurlits on 3/10/21.
//

import UIKit

class MediaListViewController: UIViewController, GenericCollectionViewController, Coordinated {
    var collectionView: UICollectionView!
    var mediaController: AnyMediaListController? {
        didSet { title = mediaController?.title }
    }
    
    var searchHistoryController: SearchHistoryController?
    
    func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            let sectionLayout = GenericLayouts.createFullWidthSection(height: 150, addHeader: false)
            sectionLayout?.interGroupSpacing = 16
            return sectionLayout
        }
    }
    
    var coordinator: MainCoordinator?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    private lazy var dataSource = createDataSource()
    
    fileprivate func configureCollectionView() {
        collectionView = createCollectionView()
        collectionView.contentInset.top = 16
        
        collectionView.delegate = self
        
        collectionView.registerCell(CharacterSearchCell.self)
        collectionView.registerCell(MovieCell.self)
        collectionView.registerCell(PlaceholderCell.self)
    }
    
    func setMediaController(_ controller: AnyMediaListController?) {
        self.mediaController = controller
    }
    
    func loadFromMediaController(_ controller: AnyMediaListController?) {
        self.mediaController = controller
        controller?.load(completion: update)
    }
    
    override func viewDidLoad() {
        configureCollectionView()
        loadFromMediaController(mediaController)
    }
    
    deinit { print("media list vc deleted from memory")}
}

extension MediaListViewController {
    func update() {
        if let mediaController = mediaController {
            dataSource.apply(createSnapshot(from: mediaController))
        }
    }
        
    func createSnapshot(from controller: AnyMediaListController) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(controller.medias, toSection: .main)
        return snapshot
    }
    
    func createDataSource() -> DataSource {
        DataSource(collectionView: collectionView) { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            if let character = item as? Character, character != Character.placeholder {
                let cell = collectionView.dequeueCell(CharacterSearchCell.self, for: indexPath)
                character.viewModel.configure(cell)
                return cell
            } else if let movie = item as? Movie, movie != Movie.placeholder {
                let cell = collectionView.dequeueCell(MovieCell.self, for: indexPath)
                movie.viewModel.configure(cell)
                return cell
            } else if let tvShow = item as? TVShow, tvShow != TVShow.placeholder {
                let cell = collectionView.dequeueCell(MovieCell.self, for: indexPath)
                tvShow.viewModel.configure(cell)
                return cell
            } else {
                guard let self = self else { return nil }
                self.mediaController?.loadMore(completion: self.update)
                return collectionView.dequeueCell(PlaceholderCell.self, for: indexPath)
            }
        }
    }
}

extension MediaListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        if let character = item as? Character {
            coordinator?.showPersonInfo(character: character)
        } else if let movie = item as? Movie {
            coordinator?.showDetails(movie: movie)
            searchHistoryController?.addMedia(movie)
        } else if let tvShow = item as? TVShow {
            coordinator?.showDetails(tvShow: tvShow)
            searchHistoryController?.addMedia(tvShow)
        }
    }
}

extension MediaListViewController {
    enum Section {
        case main
    }
    
    struct ResultWrapper: Hashable {
        var item: AnyHashable
    }
}


