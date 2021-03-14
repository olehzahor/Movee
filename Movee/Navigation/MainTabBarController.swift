//
//  MainTabBarController.swift
//  Movee
//
//  Created by jjurlits on 12/10/20.
//

import UIKit

class MainTabBarController: UITabBarController {
    let coordinators: [Coordinator] = {
        let watchlistController = WatchlistController()
        
        let mainCoordinator = MainCoordinator()
        mainCoordinator.watchlistController = watchlistController
        
        let watchlistCoordinator = WatchlistCoordinator()
        watchlistCoordinator.watchlistController = watchlistController
        
        let searchCoordinator = SearchCoordinator()
        searchCoordinator.watchlistController = watchlistController
        
        return [mainCoordinator, watchlistCoordinator, searchCoordinator]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBar.standardAppearance = appearance
                
        
        coordinators.forEach { $0.start() }
        
        viewControllers = coordinators.compactMap { $0.navigationController }
    }
    
}
