////
////  MovieDetailsViewController.swift
////  Movee
////
////  Created by jjurlits on 10/31/20.
////
//
//import UIKit
//
//fileprivate let descriptionCellId = "descriptionCell"
//fileprivate let castCellId = "castCell"
//fileprivate let backdropHeaderId = "backdropHeader"
//
//extension MovieDetailsController {
//    private func configureLayout() {
//      collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(sectionProvider: { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//        let isPhone = layoutEnvironment.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.phone
//        let size = NSCollectionLayoutSize(
//          widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
//          heightDimension: NSCollectionLayoutDimension.absolute(isPhone ? 280 : 250)
//        )
//        let itemCount = isPhone ? 1 : 3
//        let item = NSCollectionLayoutItem(layoutSize: size)
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: size, subitem: item, count: itemCount)
//        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//        section.interGroupSpacing = 10
//        return section
//      })
//    }
//}
//
//class MovieDetailsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MovieViewModelDelegate {
//    
//    func didFinishLoading() {
//        collectionView.reloadData()
//    }
//    
//    var characterViewModels: [CharacterViewModel]?
//    var movieViewModel: MovieViewModel?
//    
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return .init(width: collectionView.frame.width, height: 200.0)
////    }
////
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
////        if let layout = collectionViewLayout as? MovieDetailsLayout {
////            layout.handler = { alpha in
////                self.restoreNavbar()
////            }
////        }
//        collectionView.backgroundColor = .green
//        collectionView.register(BackdropView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: backdropHeaderId)
//        collectionView.register(DescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
//        collectionView.register(CreditsCell.self, forCellWithReuseIdentifier: castCellId)
//
//        configureLayout()
////        configureCollectionView()
//        
//        movieViewModel?.delegate = self
//        movieViewModel?.fetchDetails()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        print("****about to configure navbar")
//        configureNavbar()
//        super.viewWillAppear(animated)
//        
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        restoreNavbar()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return .init(width: collectionView.frame.width, height: collectionView.frame.width)//view.frame.width / 16 * 9)
//    }
//    
////    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return .init(width: view.frame.width, height: 1000)
////    }
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 2
//    }
//    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
////
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: backdropHeaderId, for: indexPath) as! BackdropView
//
//        movieViewModel?.configure(header)
//
//        return header
//    }
//    
//    fileprivate func setupDescriptionCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! DescriptionCell
//        movieViewModel?.configure(cell)
//        return cell
//    }
//    
////    fileprivate func setupCreditsCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: castCellId, for: indexPath) as! CreditsCell
////        let creditsController = CreditsController()
////        creditsController.creditsViewModel = movieViewModel?.creditsViewModel
////        creditsController.creditsCell = cell
////        cell.horizontalController = creditsController
////        return cell
////    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row == 0 {
//            return setupDescriptionCell(collectionView, indexPath)
//        }
//        if indexPath.row == 1 {
//            return setupCreditsCell(collectionView, indexPath)
//        }
//        return UICollectionViewCell()
//    }
//    
//    fileprivate func configureCollectionView() {
//        collectionView.register(BackdropView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: backdropHeaderId)
//        collectionView.register(DescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
//        collectionView.register(CreditsCell.self, forCellWithReuseIdentifier: castCellId)
//        collectionView.contentInsetAdjustmentBehavior = .always
//        collectionView.backgroundColor = .systemBackground
//        collectionView.contentInsetAdjustmentBehavior = .never
//        collectionView.alwaysBounceVertical = true
//        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//            //layout.headerReferenceSize = CGSize(width: 0, height: 40)
//        }
//    }
//    
//    func configureNavbar() {
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//    
//    func restoreNavbar() {
//        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
//        navigationController?.navigationBar.shadowImage = nil
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//    
//    
//    init() {
//        super.init(collectionViewLayout: UICollectionViewFlowLayout())
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//
////let movieViewModel = MovieViewModel(movie: movie!, genres: genres)
//
////        if let movieViewModel = movieViewModel {
////            cell.movieViewModel = movieViewModel
////        }
//
////        cell.titleLabel.text = movie?.title
////        cell.originalTitleLabel.text = movie?.original_title
////        cell.overviewLabel.text = movie?.overview
////        let genresString = genres?.string(from: movie?.genre_ids) ?? ""
////        cell.infoLabel.text = [genresString, movie?.release_date ?? ""].joined(separator: " ・ ")
////
////        let url = URL(string: "https://image.tmdb.org/t/p/w500/\(movie!.poster_path!)")
////        cell.posterImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
//
////cell.layer.zPosition = 1
//
////if let backdropPath = movie?.backdrop_path,
////   let backdropURL = URL(string: "https://image.tmdb.org/t/p/w780\(backdropPath)") {
////    header.imageView.sd_setImage(with: backdropURL, placeholderImage: UIImage(named: "backdrop-placeholder"))
////}
