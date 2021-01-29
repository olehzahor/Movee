//
//  WatchlistViewController.swift
//  Movee
//
//  Created by jjurlits on 12/9/20.
//

import UIKit

class WatchlistViewController: MoviesListViewController {
    let placeholder: UILabel = {
        let label = UILabel()
        label.text = "Your watchlist is empty.\n\nMovies you add to your watchlist will appear here."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()

    func setupEmptyListPlaceholder() {
        guard let watchlistController = watchlistController else { return }
        collectionView.backgroundView = watchlistController.count > 0 ? nil : placeholder
        collectionView.isScrollEnabled = watchlistController.count > 0 ? true : false
    }
    
    @objc func watchlistUpdated() {
        if isViewLoaded {
            watchlistController?.load(completion: update(with:))
            setupEmptyListPlaceholder()
        }
    }
    
    var watchlistController: WatchlistController? {
        didSet {
            if let watchlistController = watchlistController {
                setMoviesController(watchlistController)
                NotificationCenter.default.addObserver(self, selector: #selector(watchlistUpdated), name: WatchlistController.ncUpdateName, object: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmptyListPlaceholder()
    }
    
}
