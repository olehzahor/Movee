//
//  SeasonViewController.swift
//  Movee
//
//  Created by jjurlits on 2/23/21.
//

import UIKit

struct EpisodeContainer: Hashable {
    var episode: Episode
    var isExpanded: Bool
}

class SeasonViewController: UIViewController, GenericCollectionViewController, Coordinated {
    weak var coordinator: MainCoordinator?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, EpisodeContainer>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, EpisodeContainer>
    
    var collectionView: UICollectionView!
    private(set) lazy var dataSource = createDataSource()

    var expandedEpisodes: [Int] = []
    var seasonController: SeasonController?
            
    private func setupCollectionView() {
        collectionView = createCollectionView()
        collectionView.contentInset.top = 16
        collectionView.delegate = self
        registerCell(EpisodeCell.self)
    }
    
    override func viewDidLoad() {
        setupCollectionView()
        title = seasonController?.title
        seasonController?.load(completion: update)
    }
}

extension SeasonViewController: UICollectionViewDelegate {
    private func expandEpisode(_ episodeNumber: Int) {
        expandedEpisodes.append(episodeNumber)
    }
    
    private func collapseEpisode(_ episodeNumber: Int) {
        expandedEpisodes.removeAll(where: { $0 == episodeNumber })
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let episodeNumber = dataSource.itemIdentifier(for: indexPath)?.episode.episode_number
        else { return }
        if expandedEpisodes.contains(episodeNumber) {
            collapseEpisode(episodeNumber)
        } else { expandEpisode(episodeNumber) }
        update()
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
}

extension SeasonViewController {
    var episodeContainers: [EpisodeContainer] {
        guard let episodes = seasonController?.episodes else { return [] }
        return episodes.compactMap {
            guard let episodeNumber = $0.episode_number else { return nil }
            let isExpanded = self.expandedEpisodes.contains(episodeNumber)
            return EpisodeContainer(episode: $0, isExpanded: isExpanded)
        }
    }
    
    func update() {
        dataSource.apply(createSnapshot())
    }
    
    func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(episodeContainers)
        return snapshot
    }
    
    func createDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { (collectionView, indexPath, episodeContainer) -> UICollectionViewCell? in
            let episode = episodeContainer.episode
            let isExpanded = episodeContainer.isExpanded
            
            let cell = self.dequeueCell(EpisodeCell.self, for: indexPath)
            episode.viewModel.configure(cell, isExpanded: isExpanded)
            return cell
        }
    }
}

extension SeasonViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            let section = GenericLayouts.createFullWidthSection()
            section?.interGroupSpacing = 24
            return section
        }
    }
}

extension SeasonViewController {
    enum Section { case main }
}
