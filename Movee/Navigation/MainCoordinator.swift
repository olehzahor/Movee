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
    var navigationBarAppearance: UINavigationBarAppearance?
    //var watchlistController: WatchlistController?
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupNavigationBar()
    }

    
    func start() {
        navigationController.navigationBar.prefersLargeTitles = true
        createAndPush(HomeViewController.self, animated: false) {
            //$0.watchlistController = self.watchlistController
            $0.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        }
    }
        
    func showDetails<T: Media>(media: T) {
        switch media.mediaType {
        case .movie:
            showDetails(movie: media as? Movie)
        case .tvShow:
            showDetails(tvShow: media as? TVShow)
        default:
            return
        }
    }
        
    func showDetails(movie: Movie?) {
        guard let movie = movie else { return }
        createAndPush(MediaDetailsViewController<Movie>.self) {
            //$0.watchlistController = self.watchlistController
            $0.mediaController = MovieController(movie)
        }
    }

    func showDetails(tvShow: TVShow?) {
        guard let tvShow = tvShow else { return }
        createAndPush(MediaDetailsViewController<TVShow>.self) {
            //$0.watchlistController = self.watchlistController
            $0.mediaController = TVShowController(tvShow)
        }
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
    
    func showRelated<T: Media>(to media: T) {
        var mediaController: AnyMediaListController?
        guard let mediaId = media.id, let mediaTitle = media.title else { return }
        switch media.mediaType {
        case .movie:
            mediaController = MediaListController<Movie>.relatedMoviesList(movieId: mediaId, name: mediaTitle)
        case .tvShow:
            mediaController = MediaListController<TVShow>.relatedTVShowsList(tvShowId: mediaId, name: mediaTitle)
        default:
            return
        }
        createAndPush(MediaListViewController.self) {
            $0.setMediaController(mediaController)
        }
    }
    
    func showCustomMediaList(mediaController: AnyMediaListController?) {
        let vc = MediaListViewController()
        vc.setMediaController(mediaController)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showMovieCredits(_ controller: PersonController) {
        let vc = MovieCreditsController()
        vc.coordinator = self
        vc.personController = controller
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showFilteredMovies(filter: Filter) {
        createAndPush(MediaListViewController.self) {
            $0.setMediaController(
                MediaListController<Movie>.filteredMovies(filter: filter))
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
    
    func showSeasonDetails(season: Season, tvShowId: Int) {
        createAndPush(SeasonViewController.self) {
            let seasonController = SeasonController(tvShowId: tvShowId, season: season)
            $0.seasonController = seasonController
        }
    }
}

extension MainCoordinator {
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
}
