//
//  CharacterController.swift
//  Movee
//
//  Created by jjurlits on 11/30/20.
//

import UIKit

extension PersonViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let section = findSection(at: indexPath, in: dataSource)
        return section == .knownFor
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = findSection(at: indexPath, in: dataSource)
        if section == .knownFor {
            navigateToMovieDetails(from: indexPath)
        }
    }
    
    func navigateToMovieDetails(from indexPath: IndexPath) {
        guard let movie = dataSource?.itemIdentifier(for: indexPath) as? Movie else { return }
        coordinator?.showDetails(movie: movie)
    }
    
    func navigateToMovieCredits() {
        coordinator?.showMovieCredits(personController)
    }
}

class PersonViewController: UIViewController, GenericCollectionViewController, Coordinated {
    weak var coordinator: MainCoordinator?
    
    typealias DataSource = UICollectionViewDiffableDataSource<PersonViewController.Section, AnyHashable>
    private(set) var personController: PersonController!
    var character: Character?
    var photo: UIImage?
    var dataSource: DataSource?
    var snapshot: NSDiffableDataSourceSnapshot<Section, AnyHashable>?
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        guard let character = character else {
            fatalError()
        }
        
        
        super.viewDidLoad()
        
        personController = PersonController(character: character)
        personController.updateHandler = update(with:)

        setupCollectionView()
        
        createDataSource()
        dataSource?.apply(
            createSnapshot(from: personController),
            animatingDifferences: true)
        
        personController.load()
        title = personController.person.name
    }
        
    func setupCollectionView() {
        collectionView = createCollectionView()
        
        collectionView.delegate = self
        
        registerCell(BiographyCell.self)
        registerCell(PersonPhotoCell.self)
        registerCell(KeyValueCell.self)
        registerCell(CompactMovieCell.self)
        
        registerHeader(SectionHeader.self)
    }
    
    func findSection(at indexPath: IndexPath) -> Section? {
        return dataSource?.snapshot().sectionIdentifiers[indexPath.section]
    }
    
    func findSection(contains item: AnyHashable) -> Section? {
        return dataSource?.snapshot().sectionIdentifier(containingItem: item)
    }
    
}

extension PersonViewController {
    func update(with controller: PersonController) {
        let snapshot = createSnapshot(from: controller)
        dataSource?.apply(snapshot, animatingDifferences: true) {
            if #available(iOS 14.3, *) {
               self.dataSource?.apply(snapshot, animatingDifferences: true)
            }
        }
    }
    
    func createSnapshot(from controller: PersonController) -> NSDiffableDataSourceSnapshot<Section, AnyHashable> {
        var snapshot : NSDiffableDataSourceSnapshot<Section, AnyHashable>?  = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        
        if controller.viewModel?.imageURL != nil {
            snapshot?.appendSections([.photoAndName])
            snapshot?.appendItems([controller.person], toSection: .photoAndName)
        }
        
        let personalInfo = controller.personalInfoDictionary
        if !personalInfo.isEmpty {
            snapshot?.appendSections([.personalInfo])
            snapshot?.appendItems(personalInfo, toSection: .personalInfo)
        }

        if let biography = controller.person?.biography, !biography.isEmpty {
            snapshot?.appendSections([.biography])
            snapshot?.appendItems([biography], toSection: .biography)
        }
        
        let knownFor = controller.knownFor
        if !knownFor.isEmpty {
            snapshot?.appendSections([.knownFor])
            snapshot?.appendItems(knownFor, toSection: .knownFor)
        }
        
        print("created snapshot")
        self.snapshot = snapshot
        return snapshot!
    }
    
    func createDataSource() {
        dataSource =  DataSource(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = self.findSection(contains: item) else { return nil }
            switch section {
            case .photoAndName:
                let cell = self.dequeueCell(PersonPhotoCell.self, for: indexPath)
                self.personController.viewModel?.configure(cell)
                return cell
            
            case .personalInfo:
                guard let item = item as? PersonController.PersonalInfo else {
                    return nil
                }
                
                let cell = self.dequeueCell(KeyValueCell.self, for: indexPath)
                
                cell.keyLabel.text = item.key
                cell.valueLabel.text = item.value
                
                return cell
                
            case .biography:
                let cell = self.dequeueCell(BiographyCell.self, for: indexPath)
                self.personController.viewModel?.configure(cell)
                return cell
                
            case .knownFor:
                let cell = self.dequeueCell(CompactMovieCell.self, for: indexPath)
                if let movie = item as? Movie {
                    let vm = MovieViewModel(movie: movie)
                    vm.configure(cell)
                }
                return cell
            }
            
        }
        
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            guard let section = self.findSection(at: indexPath) else { return nil }
            let header = self.dequeueHeader(SectionHeader.self, for: indexPath)
            header.titleLabel.text = section.title
            if section == .knownFor {
                header.setAction(title: "See All",
                                 action: self.navigateToMovieCredits) }
            return header
        }

    }
}

extension PersonViewController {   
    enum Section: Hashable {
        case photoAndName
        case personalInfo
        case biography
        case knownFor
        
        var title: String {
            switch self {
            case .personalInfo:
                return "Personal Information"
            case .biography:
                return "Biography"
            case .knownFor:
                return "Known For"
            default:
                return ""
            }
        }
    }
}
