//
//  MainTabBarController.swift
//  Movee
//
//  Created by jjurlits on 12/10/20.
//

import UIKit

class MainTabBarController: UITabBarController {
    let coordinators: [Coordinator] = {
        let mainCoordinator = MainCoordinator()
        let watchlistCoordinator = WatchlistCoordinator()
        let searchCoordinator = SearchCoordinator()
        
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
