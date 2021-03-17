//
//  FiltersViewController.swift
//  Movee
//
//  Created by jjurlits on 12/12/20.
//

import UIKit


class FiltersViewController: UIViewController, Coordinated {
    var coordinator: SearchCoordinator?

    typealias DataSource = UICollectionViewDiffableDataSource<FilterController.Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<FilterController.Section, AnyHashable>
    
    private(set) lazy var dataSource = createDataSource()
    private(set) var filterController = FilterController()

    var collectionView: UICollectionView!
    
    var isGenresCollapsed = true {
        didSet {
            filterController.shortGenres = isGenresCollapsed
            update(animated: true)
        }
    }
        
    @objc func navigateToResults() {
        coordinator?.showFilteredMovies(
            filter: filterController.filter)
    }
    
    @objc func resetOptions() {
        filterController.reset()
        update(animated: true)
    }

    
    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        title = "Advanced Search"
        
        
        let findButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain, target: self,
            action: #selector(navigateToResults))
        
        let resetButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"),
            style: .plain, target: self,
            action: #selector(resetOptions))
        
        navigationItem.rightBarButtonItems = [findButton, resetButton]
        
        collectionView = createCollectionView(layout: createLayout())
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
        
        collectionView.registerCell(OptionCell.self)
        collectionView.registerFooter(HintFooter.self)
        collectionView.registerHeader(SectionHeader.self)
        
        
        dataSource.apply(createSnapshot())
    }
    
}

extension FiltersViewController:  UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if let option = dataSource.itemIdentifier(for: indexPath) as? FilterController.Option {
            option.pick()
        }
        collectionView.deselectItem(at: indexPath, animated: false)
        update(animated: true)
    }
}


extension FiltersViewController {
    func update(animated: Bool) {
        dataSource.apply(createSnapshot(), animatingDifferences: animated)
    }
    
    func createDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueCell(OptionCell.self, for: indexPath)
            guard let item = item as? FilterController.Option else { return cell }

            cell.label.text = item.name
            cell.option = item.name
            
            cell.setState(item.state)
            
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            guard let section = dataSource.findSection(at: indexPath) else { return nil }
            
            let header = collectionView.dequeueHeader(SectionHeader.self, for: indexPath)
            header.titleLabel.text = section.title
            
            if section == .genres {
                header.setAction(title: "Show More", secondaryTitle: "Show Less") {
                    self.isGenresCollapsed = !self.isGenresCollapsed
                }
            }
            
            return header
        }
        
        return dataSource
    }
    

    func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        for section in FilterController.Section.allCases {
            snapshot.appendSections([section])
            snapshot.appendItems(
                filterController.options(forSection: section),
                toSection: section)
        }
        
        return snapshot
    }
}
