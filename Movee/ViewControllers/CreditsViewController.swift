//
//  CastViewController.swift
//  Movee
//
//  Created by jjurlits on 11/11/20.
//

import UIKit

class CreditsViewController: UIViewController, GenericCollectionViewController, Coordinated {
    weak var coordinator: MainCoordinator?
    
    typealias DataSource = UICollectionViewDiffableDataSource<String, Character>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, Character>
    
    var credits: Credits?
    
    private(set) lazy var dataSource = createDataSource()
    
    var collectionView: UICollectionView!
    private var creditsController: CreditsController?

    override func viewDidLoad() {
        guard let credits = credits else {
            fatalError("Credits View Controller initialized without any credits!")
        }
        
        super.viewDidLoad()
        
        
        creditsController = .init(credits: credits)
        setupCollectionView()
        dataSource.apply(createSnapshot())
    }
    
    func setupCollectionView() {
        collectionView = createCollectionView()
        collectionView.delegate = self

        collectionView.contentInset = .init(top: 16, left: 0, bottom: 0, right: 0)
        
        registerCell(CharacterHorizontalCell.self)
        registerHeader(CreditsSectionHeader.self)
    }
}

extension CreditsViewController {
    func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        guard let credits = creditsController?.long else { return snapshot }
        
        credits.forEach {
            snapshot.appendSections([$0])
            snapshot.appendItems($1, toSection: $0)
        }
        
        return snapshot
    }
    
    func createDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) {
            (collectionView, indexPath, character) -> UICollectionViewCell? in
            let cell = self.dequeueCell(CharacterHorizontalCell.self, for: indexPath)
            character.viewModel.configure(cell)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            guard let section = self.findSection(at: indexPath, in: self.dataSource) else { return nil }
            let header = self.dequeueHeader(CreditsSectionHeader.self, for: indexPath)
            header.titleLabel.text = section
            return header
        }
        
        return dataSource
    }
}

extension CreditsViewController: UICollectionViewDelegate {
    func navigateToPerson(from indexPath: IndexPath) {
        guard let character = dataSource.itemIdentifier(for: indexPath)
        else { return }
        coordinator?.showPersonInfo(character: character)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigateToPerson(from: indexPath)
    }
}
