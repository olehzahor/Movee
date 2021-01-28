//
//  PersonMovieCreditsController.swift
//  Movee
//
//  Created by jjurlits on 12/2/20.
//

import UIKit

extension MovieCreditsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource?.itemIdentifier(for: indexPath)
        else { return }
        
        coordinator?.showDetails(movie: movie)
    }
}

class MovieCreditsController: UIViewController, GenericCollectionViewController, Coordinated {
    weak var coordinator: MainCoordinator?
    
    typealias DataSource = UICollectionViewDiffableDataSource<String, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, Movie>
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
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        
        registerCell(MovieListCell.self)
        registerHeader(SectionHeader.self)
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
            snapshot?.appendItems($0.items, toSection: $0.department)
        }
        
        return snapshot!

    }
    
    func createDataSource() {
        dataSource =  DataSource(collectionView: collectionView) {
            (collectionView, indexPath, movie) -> UICollectionViewCell? in
            let cell = self.dequeueCell(MovieListCell.self, for: indexPath)
            MovieViewModel(movie: movie).configure(cell)
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            guard let section = self.findSection(at: indexPath, in: self.dataSource) else { return nil }
            
            let header = self.dequeueHeader(SectionHeader.self, for: indexPath)
            header.titleLabel.text = section
            return header
        }
    }
    
    
}
