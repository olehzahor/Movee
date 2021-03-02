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
        createAndPush(NewHomeViewController.self, animated: false) {
            $0.watchlistController = self.watchlistController
            $0.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        }
//
//        createAndPush(MediaListViewController<AnyMedia>.self, animated: false) {
//            let controller = TMDBMediaListController<AnyMedia>(title: "Popular Shows") { (page, completion) -> URLSessionTask? in
//                TMDBClient.shared.getPopularMovies(page: page, completion: completion)
//            }
//
//            $0.setMediaController(controller)
//        }
        

    }
    
    func showDetails(movie: Movie) {
        let vc = MediaDetailsViewController(MediaController(movie))//MovieDetailsViewController()
        vc.coordinator = self
        //vc.movie = movie
        vc.watchlistController = watchlistController
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showMediaDetails(media: Media) {
        switch media {
        case is Movie:
            showMovieDetails(movie: media as! Movie)
        case is TVShow:
            showTVShowDetails(tvShow: media as! TVShow)
        default:
            return
        }
    }
    
//    func showMediaDetails<MediaType: Media>(media: MediaType) {
//        //showMovieDetails(movie: media as! Movie)
//        print(MediaType.self)
//        if MediaType.self == Movie.self {
//            showMovieDetails(movie: media as! Movie)
//        } else if MediaType.self == TVShow.self {
//            showTVShowDetails(tvShow: media as! TVShow)
//        }
//    }
    
    func showMovieDetails(movie: Movie) {
        createAndPush(MediaDetailsViewController.self) {
            $0.mediaController = MovieController(movie)
        }
    }
    
    func showTVShowDetails(tvShow: TVShow) {
        createAndPush(MediaDetailsViewController.self) {
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
    
    func showCustomMediaList(mediaController: MediaListController?) {
        if let moviesController = mediaController as? TMDBMediaListController<Movie> {
            createAndPush(MediaListViewController.self) {
                $0.setMediaController(moviesController)
            }
        } else if let tvShowsController = mediaController as? TMDBMediaListController<TVShow> {
            createAndPush(MediaListViewController.self) {
                $0.setMediaController(tvShowsController)
            }
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
    
    func showSeasonDetails(season: Season, tvShowId: Int) {
        createAndPush(SeasonViewController.self) {
            let seasonController = SeasonController(tvShowId: tvShowId, season: season)
            $0.seasonController = seasonController
        }
    }
}
