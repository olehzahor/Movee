//
//  PersonMovieCreditsController.swift
//  Movee
//
//  Created by jjurlits on 12/2/20.
//

import UIKit

class TimelineViewController: UIViewController, Coordinated {
    weak var coordinator: MainCoordinator?
    
    typealias DataSource = UICollectionViewDiffableDataSource<String, Movie.UniqueMovieContainer>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, Movie.UniqueMovieContainer>
    var dataSource: DataSource?

    var collectionView: UICollectionView!
    var personController: PersonController!
    
    override func viewDidLoad() {
        if personController == nil {
            fatalError("Movie credits controller initialized without person controller.")
        }
        
        super.viewDidLoad()
        setupCollectionView()
        createDataSource()
        dataSource?.apply(createSnapshot()!, animatingDifferences: false)
    }
    
    
    func setupCollectionView() {
        collectionView = createCollectionView(layout: createLayout())
        collectionView.delegate = self
        
        collectionView.registerCell(MovieListCell.self)
        collectionView.registerHeader(SectionHeader.self)
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            return GenericLayouts.createFullWidthSection(addHeader: true)
        }
    }
    
    func createSnapshot() -> Snapshot? {
        var snapshot: Snapshot? = Snapshot()
        
        guard let sections = personController.movieCredits else { fatalError() }
        
        sections.forEach {
            snapshot?.appendSections([$0.department])
            snapshot?.appendItems($0.items.map({$0.unique}), toSection: $0.department)
        }
        
        return snapshot!

    }
    
    func createDataSource() {
        dataSource =  DataSource(collectionView: collectionView) {
            (collectionView, indexPath, container) -> UICollectionViewCell? in
            let cell = collectionView.dequeueCell(MovieListCell.self, for: indexPath)
            MovieViewModel(movie: container.movie).configure(cell)
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let section = self?.dataSource?.findSection(at: indexPath) else { return nil }
            
            let header = collectionView.dequeueHeader(SectionHeader.self, for: indexPath)
            header.titleLabel.text = section
            return header
        }
    }
}


extension TimelineViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let container = dataSource?.itemIdentifier(for: indexPath)
        else { return }
        
        coordinator?.showDetails(media: container.movie)
    }
}

extension Movie {
    struct UniqueMovieContainer: Hashable {
        let id = UUID()
        let movie: Movie
    }
    
    var unique: UniqueMovieContainer {
        return UniqueMovieContainer(movie: self)
    }
}
