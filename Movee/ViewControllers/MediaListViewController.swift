//
//  MediaListViewController.swift
//  Movee
//
//  Created by jjurlits on 2/26/21.
//

import UIKit

class MediaListViewController<T: Media>: UIViewController, GenericCollectionViewController, Coordinated, UICollectionViewDelegate {
    weak var coordinator: MainCoordinator?
    
    var trackHistory: Bool = false
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, T>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, T>
    private lazy var dataSource = createDataSource()

    var collectionView: UICollectionView!
    private(set) var mediaController: MediaListController!
    
    func setMediaController(_ mediaController: MediaListController) {
        self.mediaController = mediaController
    }
    
    func loadFromController(_ mediaController: MediaListController) {
        setMediaController(mediaController)
        mediaController.load(completion: update)
    }
    
    fileprivate func loadFromMediaController() {
        mediaController?.load(completion: update)
    }
    
    fileprivate func setupCollectionView() {
        collectionView = createCollectionView()
        collectionView.contentInset.top = 8
        collectionView.delegate = self
        
        registerCell(MovieCell.self)
        registerCell(PlaceholderCell.self)
    }

    
    fileprivate func setupNavigationItem() {
        title = mediaController?.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationItem()
        
        loadFromMediaController()
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let media = dataSource.itemIdentifier(for: indexPath) else { return }
        coordinator?.showDetails(media: media)
    }
    
    convenience init(mediaController: MediaListController) {
        self.init()
        setMediaController(mediaController)
    }
}



//MARK:- Data Source
internal extension MediaListViewController {
    func update() {
        dataSource.apply(createSnapshot())
    }
    
    func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        
        guard let medias = mediaController?.medias else { return snapshot }

        snapshot.appendSections([.main])
        snapshot.appendItems(medias as! [T])
        return snapshot
    }
    
    func createDataSource() -> DataSource {
        return DataSource(
            collectionView: collectionView,
            cellProvider: { [self] (collectionView, indexPath, media) -> UICollectionViewCell? in
                if media == T.placeholder() {
                    let cell = dequeueCell(PlaceholderCell.self, for: indexPath)
                    self.mediaController?.loadMore(completion: update)
                    return cell
                }
                
                let cell = dequeueCell(MovieCell.self, for: indexPath)
                media.viewModel.configure(cell)
                return cell
            })
    }
}

extension MediaListViewController {
    enum Section {
        case main
    }
}
