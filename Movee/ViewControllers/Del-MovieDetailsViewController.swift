////
////  ModernDetailsController.swift
////  Movee
////
////  Created by jjurlits on 11/17/20.
////
//
//import UIKit
//
//class MovieDetailsViewController: UIViewController, GenericCollectionViewController, Coordinated {
//    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
//
//    weak var coordinator: MainCoordinator?
//
//    var movie: Movie? {
//        didSet { movieId = movie?.id }
//    }
//    var movieId: Int?
//
//    var collectionView: UICollectionView!
//    internal var movieController: MovieController!
//
//    var watchlistController: WatchlistController?
//
//
//    private(set) lazy var dataSource = createDataSource()
//
//    private var savedNavBarAlpha: CGFloat = 0
//    private lazy var navBarShadowAlpha: CGFloat = {
//        return navBarAppearance.shadowColor?.rgba.alpha ?? 1
//    }()
//
//    private var navBarAlpha: CGFloat = 0.0 {
//        didSet { setupNavBarAppearance() }
//    }
//
//    private var navBarAppearance: UINavigationBarAppearance = {
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = .systemBackground
//        return appearance
//    }()
//
//    func setupMovieController() {
//        if let movie = movie {
//            movieController = MovieController(
//                movie: movie, updateHandler: update(with:))
//        } else if let movieId = movieId {
//            movieController = MovieController(
//                movieId: movieId, updateHandler: update(with:))
//        }
//    }
//
//    func setupCollectionView() {
//        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
//        view.addSubview(collectionView)
//
//        collectionView.backgroundColor = .systemBackground
//
//        collectionView.anchor(top: view.topAnchor,
//                              leading: view.leadingAnchor,
//                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
//                              trailing: view.trailingAnchor)
//
//        if movieController.isBackdropAvaiable {
//            collectionView.contentInsetAdjustmentBehavior = .never
//        }
//
//        collectionView.delegate = self
//
//        registerHeader(BackdropView.self)
//        registerHeader(SectionHeader.self)
//
//        registerCell(DescriptionCell.self)
//        registerCell(CharacterCell.self)
//        registerCell(CompactMovieCell.self)
//        registerCell(TrailerCell.self)
//        registerCell(KeyValueCell.self)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        navBarAlpha = savedNavBarAlpha
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        savedNavBarAlpha = navBarAlpha
//        self.resetNavbarTintColor()
//    }
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupMovieController()
//        setupCollectionView()
//
//
//        title = movieController.viewModel?.title
//        navigationItem.titleView?.alpha = 0
//        navigationItem.largeTitleDisplayMode = .never
//        setupNavigationBarButtons()
//        dataSource.apply(createSnapshot(controller: movieController), animatingDifferences: true)
//
//        movieController.load()
//    }
//}
//
////MARK: - Navigation Bar Setup
//extension MovieDetailsViewController {
//    func setupNavBarAppearance() {
//        guard movieController.isBackdropAvaiable else { return }
//        navBarAppearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(navBarAlpha)
//        navBarAppearance.shadowColor =
//            navBarAppearance.shadowColor?.withAlphaComponent(navBarShadowAlpha * navBarAlpha)
//
//        let titleTextAlpha: CGFloat = navBarAlpha < 0.9 ? 0 : (navBarAlpha - 0.9) * 10
//        let titleTextColor = UIColor.label.withAlphaComponent(titleTextAlpha)
//        navBarAppearance.titleTextAttributes = [.foregroundColor:titleTextColor]
//
//        navigationItem.standardAppearance = navBarAppearance
//        navigationItem.scrollEdgeAppearance = navBarAppearance
//        navigationItem.compactAppearance = navBarAppearance
//        manageNavbarTintColor()
//
//    }
//
//    func manageNavbarTintColor() {
//        let alpha = navBarAlpha
//        var tintColor = view.tintColor ?? UIColor.label
//
//        if self.traitCollection.userInterfaceStyle == .dark {
//            tintColor = UIColor.init(
//                hue: tintColor.hsb.hue,
//                saturation: tintColor.hsb.saturation * alpha,
//                brightness: tintColor.hsb.brightness,
//                alpha: 1.0)
//        } else {
//            tintColor = UIColor.init(
//                hue: tintColor.hsb.hue,
//                saturation: tintColor.hsb.saturation,
//                brightness: tintColor.hsb.brightness * alpha,
//                alpha: 1.0)
//        }
//        navigationController?.navigationBar.tintColor = tintColor
//
//    }
//
//    func resetNavbarTintColor() {
//        navigationController?.navigationBar.tintColor = nil
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let contentOffsetY = scrollView.contentOffset.y
//
//        let maxOffset = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0))?.frame.height ?? 100
//
//        if contentOffsetY > 0 && contentOffsetY <= maxOffset {
//            let alpha = contentOffsetY / maxOffset
//            navBarAlpha = alpha
//        }
//        else if contentOffsetY <= 0 {
//            navBarAlpha = 0
//        }
//        else if contentOffsetY > maxOffset {
//            navBarAlpha = 1
//        }
//    }
//}
//
//
////MARK: - Watchlist Setup
//extension MovieDetailsViewController {
//    @objc func addToWatchlist() {
//        watchlistController?.addMovie(movieController.movie!)
//        setupNavigationBarButtons()
//    }
//
//    @objc func removeFromWatchlist() {
//        watchlistController?.removeMovie(movieController.movie!)
//        setupNavigationBarButtons()
//    }
//
//    fileprivate func setupNavigationBarButtons() {
//        guard let movie = movieController.movie,
//              let watchlistController = watchlistController
//        else { return }
//
//        let addToWatchlistButton = UIBarButtonItem(
//            image: UIImage(systemName: "bookmark"),
//            style: .plain,
//            target: self,
//            action: #selector(addToWatchlist))
//
//        let removeFromWatchlistButton = UIBarButtonItem(
//            image: UIImage(systemName: "bookmark.slash"),
//            style: .plain,
//            target: self,
//            action: #selector(removeFromWatchlist))
//
//        self.navigationItem.rightBarButtonItem =
//            watchlistController.contains(movie) ? removeFromWatchlistButton : addToWatchlistButton
//    }
//}
//
////MARK: - Data Source
//extension MovieDetailsViewController {
//    func update(with controller: MovieController) {
//        self.movie = controller.movie
//        dataSource.apply(createSnapshot(controller: controller))
//    }
//
//    func createSnapshot(controller: MovieController) -> NSDiffableDataSourceSnapshot<Section, AnyHashable> {
//        var snapshot = Snapshot()
//
//        snapshot.appendSections([.description])
//        snapshot.appendItems([controller.movie], toSection: .description)
//
//        if let trailer = controller.trailer {
//            snapshot.appendSections([.trailer])
//            snapshot.appendItems([trailer], toSection: .trailer)
//        }
//
//        if let credits = controller.creditsController?.short, !credits.isEmpty {
//            snapshot.appendSections([.credits])
//            snapshot.appendItems(credits, toSection: .credits)
//        }
//
//        if let related = controller.related, !related.isEmpty {
//            snapshot.appendSections([.related])
//            snapshot.appendItems(related, toSection: .related)
//        }
//
//        if !controller.generalInfo.isEmpty {
//            snapshot.appendSections([.info])
//            snapshot.appendItems(controller.generalInfo, toSection: .info)
//        }
//
//        return snapshot
//    }
//
//    func createDataSource() -> DataSource {
//        let dataSource = DataSource(collectionView: collectionView) {
//            (collectionView, indexPath, item) -> UICollectionViewCell? in
//            guard let section = self.findSection(at: indexPath, in: self.dataSource) else {
//                fatalError("Couldn't find section at index: \(indexPath)")
//            }
//            switch section {
//            case .description:
//                let cell = self.dequeueCell(DescriptionCell.self, for: indexPath)
//                self.movieController.viewModel?.configure(cell)
//                return cell
//            case .trailer:
//                let cell = self.dequeueCell(TrailerCell.self, for: indexPath)
//                if let video = item as? VideoResult {
//                    cell.placeholder.sd_setImage(with: self.movieController.viewModel?.backdropURL)
//                    cell.trailerNameLabel.text = video.name
//                    cell.setVideo(id: video.key ?? "")
//                }
//                return cell
//            case .credits:
//                let cell = self.dequeueCell(CharacterCell.self, for: indexPath)
//                if let character = item as? Character {
//                    character.viewModel.configure(cell)
//                }
//                return cell
//            case .related:
//                let cell = self.dequeueCell(CompactMovieCell.self, for: indexPath)
//                if let movie = item as? Movie {
//                    movie.viewModel.configure(cell)
//                }
//                return cell
//            case .info:
//                let cell = self.dequeueCell(KeyValueCell.self, for: indexPath)
//                if let row = (item as? [String: String])?.first {
//                    cell.keyLabel.text = row.key
//                    cell.valueLabel.text = row.value
//                }
//                return cell
//            }
//
//        }
//
//        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
//            guard let self = self else { return nil }
//            guard let section = self.findSection(at: indexPath, in: self.dataSource) else { return nil }
//
//            if section == .description {
//                let backdrop = self.dequeueHeader(BackdropView.self, for: indexPath)
//                self.movieController.viewModel?.configure(backdrop)
//                return backdrop
//            }
//
//            let sectionHeader = self.dequeueHeader(SectionHeader.self, for: indexPath)
//            sectionHeader.titleLabel.text = section.title
//            print(section)
//
//            switch section {
//            case .related:
//                sectionHeader.setAction(title: "See All") {
//                    self.navigateToRelatedList()
//                }
//            case .credits:
//                sectionHeader.setAction(title: "See All") {
//                    self.navigateToCredits()
//                }
//            default:
//                break
//            }
//
//            return sectionHeader
//        }
//
//        return dataSource
//    }
//}
//
//
////MARK: - Navigation
//extension MovieDetailsViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let section = findSection(at: indexPath, in: dataSource)
//
//        switch section {
//        case .credits:
//            navigateToPersonInfo(from: indexPath)
//        case .related:
//            navigateToMovieDetails(from: indexPath)
//        default:
//            return
//        }
//    }
//
//    @objc func navigateToCredits() {
//        guard let credits = movieController.movie?.credits else { return }
//        coordinator?.showCredits(credits)
//    }
//
//    @objc func navigateToRelatedList() {
//        guard let movie = movie else { return }
//        coordinator?.showRelated(to: movie)
//    }
//
//    func navigateToMovieDetails(from indexPath: IndexPath) {
//        guard let movie = dataSource.itemIdentifier(for: indexPath) as? Movie else { return }
//        coordinator?.showDetails(movie: movie)
//    }
//
//    func navigateToPersonInfo(from indexPath: IndexPath) {
//        guard let character = dataSource.itemIdentifier(for: indexPath) as? Character else { return }
//        coordinator?.showPersonInfo(character: character)
//    }
//}
//
//
//extension MovieDetailsViewController {
//    enum Section: String, Hashable {
//        case description
//        case trailer
//        case credits = "Cast and Crew"
//        case related = "Related"
//        case info = "Information"
//
//        var title: String {
//            return self.rawValue
//        }
//    }
//}
