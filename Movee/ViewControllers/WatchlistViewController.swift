//
//  WatchlistViewController.swift
//  Movee
//
//  Created by jjurlits on 12/9/20.
//

import UIKit

class WatchlistViewController: MoviesListViewController {
    
    @objc func watchlistUpdated() {
        if isViewLoaded {
            watchlistController?.load(completion: update(with:))
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
    
    @objc func showWatchHistory() {
        coordinator?.showWatchHistory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let historyButton = UIBarButtonItem.init(image: UIImage.init(systemName: "clock"), style: .plain, target: self, action: #selector(showWatchHistory))
        
        navigationItem.rightBarButtonItem = historyButton
    }
}
