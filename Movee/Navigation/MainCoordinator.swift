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
    var watchlistController: WatchlistController?
    
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
            $0.watchlistController = self.watchlistController
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
//
//        createAndPush(MediaDetailsViewController.self) {
//            $0.mediaController = MediaController(media)
//        }
        
//        switch media {
//        case is Movie:
//            showDetails(movie: media as! Movie)
//        case is TVShow:
//            showDetails(tvShow: media as! TVShow)
//        default:
//            return
//        }
    }
        
    func showDetails(movie: Movie?) {
        guard let movie = movie else { return }
        createAndPush(MediaDetailsViewController<Movie>.self) {
            $0.watchlistController = self.watchlistController
            $0.mediaController = MovieController(movie)
        }
    }

    func showDetails(tvShow: TVShow?) {
        guard let tvShow = tvShow else { return }
        createAndPush(MediaDetailsViewController<TVShow>.self) {
            $0.watchlistController = self.watchlistController
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
    
//    func showRelated(to movie: Movie) {
////        guard let moviesController = TMDBMoviesListController.relatedList(to: movie)
////        else { return }
////        let vc = MoviesListViewController(moviesController: moviesController)
////        vc.coordinator = self
////        navigationController.pushViewController(vc, animated: true)
//    }
//
//    func showCustomMoviesList(moviesController: MoviesListController) {
////        createAndPush(MoviesListViewController.self) {
////            $0.setMoviesController(moviesController)
////        }
//    }
//
    func showCustomMediaList(mediaController: AnyMediaListController?) {
        let vc = MediaListViewController()
        vc.setMediaController(mediaController)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
//        createAndPush(MediaListViewController.self) { $0.loadFromController(mediaController) }
    }
//
//    func showCustomMediaList(mediaController: MediaListController?) {
//        if let moviesController = mediaController as? TMDBMediaListController<Movie> {
//            createAndPush(MediaListViewController.self) {
//                $0.setMediaController(moviesController)
//            }
//        } else if let tvShowsController = mediaController as? TMDBMediaListController<TVShow> {
//            createAndPush(MediaListViewController.self) {
//                $0.setMediaController(tvShowsController)
//            }
//        }
//    }
    
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
//{
//        didSet {
//            guard let navigationBarAppearance = navigationBarAppearance else { return }
//            navigationController.navigationBar.standardAppearance = navigationBarAppearance
//            navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
//            navigationController.navigationBar.compactAppearance = navigationBarAppearance
//
//        }
//    }


//    func showDetails(movie: Movie) {
//        let vc = MediaDetailsViewController(MediaController(movie))//MovieDetailsViewController()
//        vc.coordinator = self
//        //vc.movie = movie
//        vc.watchlistController = watchlistController
//        navigationController.pushViewController(vc, animated: true)
//    }
    
//    func showMediaDetails<T: Media>(media: T) {
//        createAndPush(MediaDetailsViewController.self) {
//            $0.mediaController = MediaController(media)
//        }
//    }
