//
//  WatchlistViewController.swift
//  Movee
//
//  Created by jjurlits on 12/9/20.
//

import UIKit

class WatchlistViewController: MediaListViewController {
    let placeholder: UILabel = {
        let label = UILabel()
        label.text = "Your watchlist is empty.\n\nMovies you add to your watchlist will appear here."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    func setupEmptyListPlaceholder() {
        let watchlistController = WatchlistController.shared
        guard watchlistController.dataState == .loaded else { return }
        collectionView.backgroundView = watchlistController.count > 0 ? nil : placeholder
        collectionView.isScrollEnabled = watchlistController.count > 0 ? true : false
    }
    
    @objc func watchlistUpdated() {
        if isViewLoaded {
            mediaController?.load { self.update() }
            setupEmptyListPlaceholder()
        }
    }
    
    @objc func updateBadgeCount() {
        let watchlistCount = WatchlistController.shared.count
        if watchlistCount > 0 {
            tabBarItem?.badgeValue = String(watchlistCount)
        } else { tabBarItem?.badgeValue = nil }
    }

    
    func setupBadge() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBadgeCount), name: WatchlistController.ncUpdatedName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateBadgeCount), name: WatchlistController.ncLoadedName, object: nil)
    }
    
    func setupWatchlist() {
        loadFromMediaController(WatchlistController.shared)
        NotificationCenter.default.addObserver(self, selector: #selector(watchlistUpdated), name: WatchlistController.ncUpdatedName, object: nil)
    }
//    var watchlistController: WatchlistController? {
//        didSet {
//            if let watchlistController = watchlistController {
//                setMediaController(watchlistController)
//                NotificationCenter.default.addObserver(self, selector: #selector(watchlistUpdated), name: WatchlistController.ncUpdatedName, object: nil)
//            }
//        }
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmptyListPlaceholder()
        setupWatchlist()
        //setupBadge()
    }
    
}
