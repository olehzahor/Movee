//
//  FiltersViewController.swift
//  Movee
//
//  Created by jjurlits on 12/12/20.
//

import UIKit

class SmartFiltersViewController: FiltersViewController {
    var segmentedControl = UISegmentedControl(items: ["Movies".l10ed, "TV Shows".l10ed])
    
    var moviesFilterController = MoviesFilterController()
    var tvShowsFilterController = TVShowsFilterController()
    
    func updateFilterController(_ controller: MoviesFilterController) {
        filterController = controller
        filterController.shortGenres = isGenresCollapsed
        update(animated: true)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0:
            updateFilterController(moviesFilterController)
            mediaType = .movie
        case 1:
            updateFilterController(tvShowsFilterController)
            mediaType = .tvShow
        default:
            return
        }
    }
    
    func setupSegmentedControl() {
        navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
    }
    
    override func viewDidLoad() {
        filterController = moviesFilterController
        mediaType = .movie
        super.viewDidLoad()
        setupSegmentedControl()
        title = "Smart Filters".l10ed
    }
}


class FiltersViewController: UIViewController, Coordinated {
    var coordinator: SearchCoordinator?

    typealias DataSource = UICollectionViewDiffableDataSource<MoviesFilterController.Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<MoviesFilterController.Section, AnyHashable>
    
    private(set) lazy var dataSource = createDataSource()
    var filterController: MoviesFilterController!
    var mediaType: MediaType = .unknown

    var collectionView: UICollectionView!
    
    var isGenresCollapsed = true {
        didSet {
            filterController.shortGenres = isGenresCollapsed
            update(animated: true)
        }
    }
        
    @objc func navigateToResults() {
        switch mediaType {
        case .movie:
            coordinator?.showFilteredMovies(filter: filterController.filter)
        case .tvShow:
            coordinator?.showFilteredTVShows(filter: filterController.filter)
        default:
            return
        }
    }
    
    @objc func resetOptions() {
        filterController.reset()
        update(animated: true)
    }

//    func createTitle() -> String {
//        var string = "Advanced "
//        if mediaType == .movie {
//            string.append("Movies ")
//        } else if mediaType == .tvShow {
//            string.append("TV Shows ")
//        }
//
//        string.append("Search")
//        return string
//    }
    
    func setupCollectionView() {
        collectionView = createCollectionView(layout: createLayout())
        collectionView.contentInset.top = 16
        collectionView.allowsMultipleSelection = true
        collectionView.delegate = self
    }
    
    fileprivate func registerCells() {
        collectionView.registerCell(OptionCell.self)
        collectionView.registerFooter(HintFooter.self)
        collectionView.registerHeader(SectionHeader.self)
    }
    
    override func viewDidLoad() {
        navigationItem.largeTitleDisplayMode = .never
        //title = createTitle()
        
        
        let findButton = UIBarButtonItem(
            image: UIImage(systemName: "magnifyingglass"),
            style: .plain, target: self,
            action: #selector(navigateToResults))
        
        let resetButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.counterclockwise"),
            style: .plain, target: self,
            action: #selector(resetOptions))
        
        navigationItem.rightBarButtonItems = [findButton, resetButton]
        
        setupCollectionView()
        registerCells()
        
        dataSource.apply(createSnapshot())
    }
    
}

extension FiltersViewController:  UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let option = dataSource.itemIdentifier(for: indexPath) as? MoviesFilterController.Option {
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
            guard let item = item as? MoviesFilterController.Option else { return cell }

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
                header.setAction(title: "Show More".l10ed, secondaryTitle: "Show Less".l10ed) {
                    self.isGenresCollapsed = !self.isGenresCollapsed
                }
            }
            
            return header
        }
        
        return dataSource
    }
    

    func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        for section in MoviesFilterController.Section.allCases {
            snapshot.appendSections([section])
            snapshot.appendItems(
                filterController.options(forSection: section),
                toSection: section)
        }
        
        return snapshot
    }
}
