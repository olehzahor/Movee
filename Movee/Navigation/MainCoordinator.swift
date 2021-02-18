//
//  MainCoordinator.swift
//  Movee
//
//  Created by jjurlits on 12/10/20.
//

import UIKit


class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var watchlistController: WatchlistController?
    
    var navigationBarAppearance: UINavigationBarAppearance? {
        didSet {
            guard let navigationBarAppearance = navigationBarAppearance else { return }
            navigationController.navigationBar.standardAppearance = navigationBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
            navigationController.navigationBar.compactAppearance = navigationBarAppearance

        }
    }
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationBarAppearance = UINavigationBarAppearance()
        guard let navigationBarAppearance = navigationBarAppearance else {
            return
        }
        
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .systemBackground
        
        navigationController.navigationBar.standardAppearance = navigationBarAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController.navigationBar.compactAppearance = navigationBarAppearance


        navigationController.navigationBar.prefersLargeTitles = true

    }
    
    func start() {
        createAndPush(HomeViewController.self, animated: false) {
            $0.watchlistController = self.watchlistController
            $0.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        }
    }
    
    func showDetails(movie: Movie) {
        let vc = MovieDetailsViewController()
        vc.coordinator = self
        vc.movie = movie
        vc.watchlistController = watchlistController
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showCredits(_ credits: Credits) {
        let vc = CreditsViewController()
        vc.coordinator = self
        vc.credits = credits
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showPersonInfo(character: Character) {
        let vc = PersonViewController()
        vc.coordinator = self
        vc.character = character
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showRelated(to movie: Movie) {
        guard let moviesController = TMDBMoviesListController.relatedList(to: movie)
        else { return }
        let vc = MoviesListViewController(moviesController: moviesController)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showCustomMoviesList(moviesController: MoviesListController) {
        createAndPush(MoviesListViewController.self) {
            $0.setMoviesController(moviesController)
        }
    }
    
    func showMovieCredits(_ controller: PersonController) {
        let vc = MovieCreditsController()
        vc.coordinator = self
        vc.personController = controller
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFilteredMovies(filter: Filter) {
        createAndPush(MoviesListViewController.self) {
            $0.setMoviesController(
                TMDBMoviesListController.filteredList(filter: filter))
        }
    }
    
    func showAdvancedSearch() {
        createAndPush(FiltersViewController.self)
    }
    
    func showNestedDiscoverList(discoverController: DiscoverController?) {
        guard let discoverController = discoverController else { return }
        createAndPush(DiscoverViewController.self) {
            $0.discoverController = discoverController
        }
    }
}
