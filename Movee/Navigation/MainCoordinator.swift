//
//  MainCoordinator.swift
//  Movee
//
//  Created by jjurlits on 12/10/20.
//

import UIKit
import WebKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var navigationBarAppearance: UINavigationBarAppearance?
    
    convenience init() {
        self.init(navigationController: UINavigationController())
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupNavigationBar()
    }
    
    func getBack() {
        navigationController.popViewController(animated: true)
    }
    
    
    struct MockListItem: Codable {
        let name: String
        let localizedNames: [String: String]?
        let path: String?
        let query: String?
        let mediaType: String?
    }
    
    func start() {
        TMDBClient.shared.loadAllGenres {
            let genres = TMDBClient.shared.genres.tv
            let ruGenres = ["Боевик и приключения","Мультфильм","Комедия","Криминал","Документальный","Драма","Семейный","Детский","Детектив","Новости","Реалити-шоу","НФ и Фэнтези","Мыльная опера","Ток-шоу","Война и Политика","Вестерн"]
            let esGenres = ["Acción y Aventura","Animación","Comedia","Crimen","Documental","Drama","Familia","Kids","Misterio","Noticias","Reality","Ciencia ficción y fantasía","Soap","Talk","Guerra y política","Western"]
            var list = [MockListItem]()
            var index = 0
            genres?.genres.forEach { genre in
                let localizedNames = ["ru": ruGenres[index], "es": esGenres[index]]
                let item = MockListItem(
                    name: "Top \(genre.name) TV Shows",
                    localizedNames: localizedNames,
                    path: "discover/tv",
                    query: "with_genres=\(genre.id)&sort_by=vote_count.desc",
                    mediaType: "tv")
                list.append(item)
                index += 1
            }
            let jsonEncoder = JSONEncoder()
            let jsonData = try? jsonEncoder.encode(list)
            let json = String(data: jsonData!, encoding: String.Encoding.utf8)
            print(json)
        }
        
        
        
        navigationController.navigationBar.prefersLargeTitles = true
        createAndPush(HomeViewController.self, animated: false) {
            $0.tabBarItem = UITabBarItem(title: NSLocalizedString("Explore", comment: ""), image: UIImage(systemName: "house"), tag: 0)
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
            $0.mediaController = MovieController(movie)
        }
    }

    func showDetails(tvShow: TVShow?) {
        guard let tvShow = tvShow else { return }
        createAndPush(MediaDetailsViewController<TVShow>.self) {
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
        let vc = TimelineViewController()
        vc.coordinator = self
        vc.personController = controller
        navigationController.pushViewController(vc, animated: true)
    }
        
    func showSeasonDetails(season: Season, tvShowId: Int) {
        createAndPush(SeasonViewController.self) {
            let seasonController = SeasonController(tvShowId: tvShowId, season: season)
            $0.seasonController = seasonController
        }
    }
    
    func showFullReview(review: Review) {
        let vc = ReviewViewController()
        vc.review = review
        vc.coordinator = self
        navigationController.present(vc, animated: true)
     }
    
    func showWikiPage(title: String) {
        guard let pageUrl = WikipediaClient.shared.getPageUrl(title)
        else { return }
        
        let vc = UIViewController()
        let webView = WKWebView()
        vc.view = webView
        webView.load(URLRequest(url: pageUrl))
        navigationController.present(vc, animated: true)
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
