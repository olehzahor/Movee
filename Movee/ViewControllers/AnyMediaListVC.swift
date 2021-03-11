//
//  AnyMediaListVC.swift
//  Movee
//
//  Created by jjurlits on 3/10/21.
//

import UIKit

class AnyMediaListVC: UIViewController, GenericCollectionViewController, Coordinated {
    var collectionView: UICollectionView!
    var mediaController: AnyMediaListControllerProtocol! {
        didSet { title = mediaController.title }
    }
    
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
        
        collectionView.delegate = self
        
        registerCell(CharacterSearchCell.self)
        registerCell(MovieCell.self)
        registerCell(PlaceholderCell.self)
    }
    
    func loadFromController(_ controller: AnyMediaListControllerProtocol) {
        self.mediaController = controller
        controller.load(completion: update)
    }
    
    override func viewDidLoad() {
        configureCollectionView()
    }
    
    var oldItems = [AnyHashable]()
}

extension AnyMediaListVC {
    func update() {
        if let searchResultsController = mediaController {
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
        DataSource(collectionView: collectionView) { (collectionView, indexPath, wrapper) -> UICollectionViewCell? in
            let item = wrapper.item
            if let character = item as? Character, character != Character.placeholder {
                let cell = self.dequeueCell(CharacterSearchCell.self, for: indexPath)
                character.viewModel.configure(cell)
                return cell
            } else if let movie = item as? Movie, movie != Movie.placeholder {
                let cell = self.dequeueCell(MovieCell.self, for: indexPath)
                movie.viewModel.configure(cell)
                print(movie.hashValue)
                return cell
            } else if let tvShow = item as? TVShow, tvShow != TVShow.placeholder {
                let cell = self.dequeueCell(MovieCell.self, for: indexPath)
                tvShow.viewModel.configure(cell)
                return cell
            } else {
                self.mediaController.loadMore(completion: self.update)
                return self.dequeueCell(PlaceholderCell.self, for: indexPath)
            }
        }
    }
}

extension AnyMediaListVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath)?.item else { return }
        if let character = item as? Character {
            coordinator?.showPersonInfo(character: character)
        } else if let movie = item as? Movie {
            coordinator?.showDetails(movie: movie)
        } else if let tvShow = item as? TVShow {
            coordinator?.showDetails(tvShow: tvShow)
        }
    }
}

extension AnyMediaListVC {
    enum Section {
        case main
    }
    
    struct ResultWrapper: Hashable {
        var item: AnyHashable
    }
}


