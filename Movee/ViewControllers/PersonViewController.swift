//
//  CharacterController.swift
//  Movee
//
//  Created by jjurlits on 11/30/20.
//

import UIKit

extension PersonViewController {
    class TitleView: UIView {
        var title: String? {
            didSet { titleLabel.text = title }
        }
        
        var subtitle: String? {
            didSet { subtitleLabel.text = subtitle }
        }
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .headline)
            label.textColor = .label
            label.textAlignment = .center
            return label
        }()
        
        let subtitleLabel: UILabel = {
            let label = UILabel()
            label.font = .preferredFont(forTextStyle: .subheadline)
            label.textColor = .secondaryLabel
            label.textAlignment = .center
            return label

        }()
                
        override init(frame: CGRect) {
            super.init(frame: frame)
            let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
            addSubview(vStack)
            vStack.axis = .vertical
            vStack.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

class PersonViewController: UIViewController, Coordinated {
    override var title: String? { didSet { titleView.title = title } }
    var subtitle: String? { didSet { self.titleView.subtitle = self.subtitle } }
    
    weak var coordinator: MainCoordinator?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    var snapshot: NSDiffableDataSourceSnapshot<Section, AnyHashable>?

    private(set) var personController: PersonController!
    var character: Character?
    var photo: UIImage?
    private(set) lazy var dataSource = createDataSource()
    var collectionView: UICollectionView!
    
    private var titleView = TitleView()
    
    private var wikiPageTitle: String? {
        didSet {
            if let wikiPageTitle = wikiPageTitle, !wikiPageTitle.isEmpty {
                UIView.transition(with: titleView, duration: 5, options: .curveEaseInOut) {
                    self.titleView.subtitleLabel.text = wikiPageTitle
                    //if wikiPageTitle != self.title { self.subtitle = wikiPageTitle }
                } completion: { _ in
                    //self.addWikipediaButton()
                    
                }

                
            }
        }
    }
    
    fileprivate func addWikipediaButton() {
        let wikiButton = UIBarButtonItem(image: UIImage(named: "icons8-wikipedia"),
                               style: .plain, target: self,
                               action: #selector(self.showWikiPage))
        self.navigationItem.setRightBarButton(wikiButton, animated: false)
    }
    
    fileprivate func setupWikipedia() {
        guard let query = character?.name else { return }
        WikipediaClient.shared.findPage(withTitle: query) { title in
            self.wikiPageTitle = title
        }
    }
    
    fileprivate func setupNavigationItem() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLoad() {
        guard let character = character else {
            fatalError()
        }
        
        
        super.viewDidLoad()
        
        setupNavigationItem()
        
        personController = PersonController(character: character)
        //personController.updateHandler = update(with:)

        setupCollectionView()
        
        dataSource.apply(
            createSnapshot(from: personController),
            animatingDifferences: true)
        
        personController.load(completion: update(with:))
        
        title = personController.person.name
        navigationItem.titleView = titleView
        
        setupWikipedia()
    }
    
        
    func setupCollectionView() {
        collectionView = createCollectionView(layout: createLayout())
        
        collectionView.delegate = self
        
        collectionView.registerCell(BiographyCell.self)
        collectionView.registerCell(PersonPhotoCell.self)
        collectionView.registerCell(KeyValueCell.self)
        collectionView.registerCell(CompactMovieCell.self)
        
        collectionView.registerHeader(SectionHeader.self)
    }    
}

extension PersonViewController {
    func update(with controller: PersonController) {
        let snapshot = createSnapshot(from: controller)
        dataSource.apply(snapshot, animatingDifferences: true)
        { [weak self] in
            if #available(iOS 14.3, *) {
               self?.dataSource.apply(snapshot, animatingDifferences: true)
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
    
    func createDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) {
            [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            guard let section = self.dataSource.findSection(contains: item) else { return nil }
            switch section {
            case .photoAndName:
                let cell = collectionView.dequeueCell(PersonPhotoCell.self, for: indexPath)
                self.personController.viewModel?.configure(cell)
                return cell
            
            case .personalInfo:
                guard let item = item as? PersonController.PersonalInfo else {
                    return nil
                }
                
                let cell = collectionView.dequeueCell(KeyValueCell.self, for: indexPath)
                
                cell.keyLabel.text = item.key
                cell.valueLabel.text = item.value
                
                return cell
                
            case .biography:
                let cell = collectionView.dequeueCell(BiographyCell.self, for: indexPath)
                self.personController.viewModel?.configure(cell)
                return cell
                
            case .knownFor:
                let cell = collectionView.dequeueCell(CompactMovieCell.self, for: indexPath)
                if let movie = item as? Movie {
                    let vm = MovieViewModel(movie: movie)
                    vm.configure(cell)
                }
                return cell
            }
            
        }
        
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            guard let section = self.dataSource.findSection(at: indexPath) else { return nil }
            let header = collectionView.dequeueHeader(SectionHeader.self, for: indexPath)
            header.titleLabel.text = section.title
            if section == .knownFor {
                header.setAction(title: NSLocalizedString("See All", comment: ""),
                                 action: { [weak self] in self?.navigateToMovieCredits() })
            }
            return header
        }
        
        return dataSource
    }
}

extension PersonViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let section = dataSource.findSection(at: indexPath)
        return section == .knownFor
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = dataSource.findSection(at: indexPath)
        if section == .knownFor {
            navigateToMovieDetails(from: indexPath)
        }
    }
    
    func navigateToMovieDetails(from indexPath: IndexPath) {
        guard let movie = dataSource.itemIdentifier(for: indexPath) as? Movie else { return }
        coordinator?.showDetails(media: movie)
    }
    
    func navigateToMovieCredits() {
        coordinator?.showMovieCredits(personController)
    }
    
    @objc func showWikiPage() {
        guard let title = wikiPageTitle else { return }
        coordinator?.showWikiPage(title: title)
    }
}


extension PersonViewController {   
    enum Section: String, Hashable {
        case photoAndName = ""
        case personalInfo = "Personal Information"
        case biography = "Biography"
        case knownFor = "Known For"
        
        var title: String {
            NSLocalizedString(rawValue, comment: "")
        }
    }
}
