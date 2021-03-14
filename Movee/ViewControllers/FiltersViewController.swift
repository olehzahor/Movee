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
    
//    var genresButtonTitle: String {
//        return self.isGenresCollapsed ? "Show More" : "Show Less"
//    }
}







//class FilterViewModel {
//    private var filter: Filter
//    init(with filter: Filter) {
//        self.filter = filter
//    }
//}

//extension FilterViewModel {
//    func configure(_ view: OptionCell, genre: Genre) {
//        view.option = genre.name
//        switch filter.state(ofGenre: genre) {
//        case .ignored:
//            view.ignore()
//        case .included:
//            view.include()
//        case .excluded:
//            view.exclude()
//        }
//    }
//}

//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        genres.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = dequeueCell(OptionCell.self, for: indexPath)
//        let genre = genres[indexPath.item]
//
//        filter.viewModel.configure(cell, genre: genre)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        if kind == UICollectionView.elementKindSectionHeader {
//            let header = dequeueHeader(SectionHeader.self, for: indexPath)
//            header.titleLabel.text = "Genres"
//            return header
//        }
//        else {
//            let footer = dequeueFooter(HintFooter.self, for: indexPath)
//            footer.label.text = "Tap once to include genre in search, tap twice to exclude it."
//            return footer
//        }
//    }
    



//
//
//extension FiltersViewController {
//    func update() {
//        dataSource.apply(createSnapshot())
//    }
//
//    func createDataSource() -> DataSource {
//        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
//            guard let section = self.findSection(at: indexPath, in: self.dataSource) else { fatalError() }
//            switch section {
//            case .genres:
//                let cell = self.dequeueCell(OptionCell.self, for: indexPath)
//                guard let genre = item as? StatedGenre else { return cell }
//
//                self.filter.viewModel.configure(cell, genre: genre.genre)
//                return cell
//            case .countries:
//                let cell = self.dequeueCell(OptionCell.self, for: indexPath)
//                cell.label.text = (item as? FilterController.Country)?.name
//                return cell
//            default:
//                let cell = self.dequeueCell(OptionCell.self, for: indexPath)
//                cell.label.text = item as? String
//                return cell
//            }
//        }
//
//        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
//            guard let self = self else { return nil }
//            guard let section = self.findSection(at: indexPath, in: self.dataSource) else { return nil }
//
//            if kind == UICollectionView.elementKindSectionHeader {
//                let header = self.dequeueHeader(SectionHeader.self, for: indexPath)
//                header.backgroundColor = .systemBackground
//
//                if section == .genres {
//                    header.titleLabel.text = "Genres"
//                    header.actionButton.setTitle(
//                        self.isGenresCollapsed ? "Show More" : "Show Less",
//                        for: .normal)
//                    header.action = {
//                        self.isGenresCollapsed = !self.isGenresCollapsed
//                        header.actionButton.setTitle(
//                            self.isGenresCollapsed ? "Show More" : "Show Less",
//                            for: .normal)
//                    }
//                } else if section == .countries {
//                    header.titleLabel.text = "Countries"
//                    header.action = {
//                        self.isCountriesCollapsed = !self.isCountriesCollapsed
//                    }
//                }
//
//                return header
//            }
//            else {
//                let footer = self.dequeueFooter(HintFooter.self, for: indexPath)
//                footer.label.text = "Tap once to include genre in search, tap twice to exclude it."
//                return footer
//            }
//        }
//
//        return dataSource
//    }
//
//
//    func createSnapshot() -> Snapshot {
//        var snapshot = Snapshot()
//        snapshot.appendSections([.genres, .countries, .rating, .votesCount, .runtimes])
//
//        var statedGenres = [StatedGenre]()
//        genres.forEach {
//            statedGenres.append(.init(genre: $0, state: self.filter.state(ofGenre: $0)))
//        }
//
//        if isGenresCollapsed {
//            snapshot.appendItems(Array(statedGenres[...9]), toSection: .genres)
//        } else {
//            snapshot.appendItems(statedGenres, toSection: .genres)
//        }
//
//        if isCountriesCollapsed {
//            snapshot.appendItems(filterController.topCountries, toSection: .countries)
//        } else {
//            snapshot.appendItems(filterController.allCountries, toSection: .countries)
//        }
//
//        snapshot.appendItems(filterController.ratings, toSection: .rating)
//        snapshot.appendItems(filterController.votesCount, toSection: .votesCount)
//        snapshot.appendItems(filterController.runtimes, toSection: .runtimes)
//        return snapshot
//    }
//}
