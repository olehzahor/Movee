//
//  TMDBClient.swift
//  Movee
//
//  Created by jjurlits on 10/27/20.
//

import Foundation

class TMDBClient: ApiService {
    //typealias PagedReusltCompletionHandler = (Result<MoviesPagedResult, Error>) -> Void
    var locale: String = "en_US"
    
    lazy var endpoints = Endpoints(apiKey: TMDB_API_KEY, locale: locale)

    var genres: StoredGenres = StoredGenres()
    private var isMovieGenresLoading = false
    private var isTvGenresLoading = false
    
    static let shared = TMDBClient()
    
    func customList<T: MediaListItem>(page: Int, path: String, query: String, completion: @escaping (Result<PagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(
            url: endpoints.customList(page: page, path: path, params: query),
            completion: completion, loadGenres: .unknown)
    }
    
    func customSinglePageList<T: SinglePageMediaListContainer>(
        path: String, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.customSinglePageList(path: path), completion: completion)
    }
    
    func themedMoviesList(listId: String, completion: @escaping (Result<ThemedList, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.themedList(id: listId), completion: completion, loadGenres: .movie)
    }

    func discoverMovies<T: Media>(filter: Filter, page: Int, completion: @escaping (Result<PagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.discoverMovies(page: page, filter: filter),
                     completion: completion)
    }
    
    func discoverTVShows<T: Media>(filter: Filter, page: Int, completion: @escaping (Result<PagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.discoverTVShows(page: page, filter: filter),
                     completion: completion)
    }

    func getPersonDetails(personId: Int, completion: @escaping (Result<Person, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.personDetails(personId: personId), completion: completion)
    }
    
    func getRelatedMovies<T: MediaListItem>(movieId: Int, page: Int,  completion: @escaping (Result<PagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.relatedMovies(movieId: movieId, page: page),
                     completion: completion, loadGenres: .movie)
    }
    
    func getRelatedTVShows<T: MediaListItem>(tvShowId: Int, page: Int,  completion: @escaping (Result<PagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.relatedTVShows(tvShowId: tvShowId, page: page),
                     completion: completion, loadGenres: .tvShow)
    }

    func getPopularMovies<T: MediaListItem>(page: Int,
                          completion: @escaping (Result<PagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.popularMovies(page: page),
                     completion: completion, loadGenres: .movie)
    }
    
    func searchMovies<T: MediaListItem>(query: String, page: Int,
                      completion: @escaping (Result<PagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchMovies(query: query, page: page),
                     completion: completion, loadGenres: .movie)
    }

    func searchTVShows<T: MediaListItem>(query: String, page: Int,
                       completion: @escaping (Result<PagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchTVShows(query: query, page: page),
                     completion: completion, loadGenres: .tvShow)
    }

    func searchPeople<T: MediaListItem>(query: String, page: Int,
                      completion: @escaping (Result<PagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchPeople(query: query, page: page),
              completion: completion)
    }

    func searchMulti<T: MediaListItem>(query: String, page: Int,
                      completion: @escaping (Result<PagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchMulti(query: query, page: page),
                     completion: completion, loadGenres: .unknown)
    }
    
    func getMovieDetails(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.movieDetails(movieId: id),
              completion: completion)
    }
    
    func getTvShowDetails(id: Int, completion: @escaping (Result<TVShow, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.tvShowDetails(tvShowId: id),
              completion: completion)
    }

    func getSeasonDetails(tvShowId: Int, seasonNumber: Int, completion: @escaping (Result<Season, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.seasonDetails(tvShowId: tvShowId, seasonNumber: seasonNumber),
              completion: completion)
    }
    
    func fullPosterUrl(path: String) -> URL? {
        return endpoints.image(path: path, size: "w500")
    }
    
    func fullBackdropUrl(path: String) -> URL? {
        return endpoints.image(path: path, size: "w780")
    }
   
    private override init() {
        super.init()
    }
}

extension TMDBClient {
    struct StoredGenres {
        var movie: Genres?
        var tv: Genres?
    }

    @discardableResult
    func getMovieGenresList(completion: @escaping (Result<Genres, Error>) -> Void) -> URLSessionTask? {
        print("start fetching movies genres")
        guard let url = endpoints.movieGenresList() else { return nil }
        return fetch(url: url, completion: completion)
        
    }
    
    @discardableResult
    func getTvGenresList(completion: @escaping (Result<Genres, Error>) -> Void) -> URLSessionTask? {
        print("start fetching tv genres")
        guard let url = endpoints.tvGenresList() else { return nil }
        return fetch(url: url, completion: completion)
        
    }
    
    func shouldFetchGenres(ofType mediaType: MediaType?) -> Bool {
        guard let mediaType = mediaType else { return false }
        switch mediaType {
        case .movie:
            return self.genres.movie == nil
        case .tvShow:
            return self.genres.tv == nil
        case .unknown:
            return self.genres.movie == nil && self.genres.tv == nil
        }
    }
    
    func loadMovieGenres(completion: ((Genres?) -> ())? = nil) {
        guard !isMovieGenresLoading else {
            completion?(genres.movie)
            return
        }
        isMovieGenresLoading = true
        getMovieGenresList { (result) in
            switch result {
            case .success(let genres):
                self.genres.movie = genres
                completion?(genres)
            case .failure(let error):
                print(error)
            }
            self.isMovieGenresLoading = false
        }
    }
    
    func loadTVGenres(completion: ((Genres?) -> ())? = nil) {
        guard !isTvGenresLoading else {
            completion?(genres.tv)
            return
        }

        isTvGenresLoading = true
        getTvGenresList { (result) in
            switch result {
            case .success(let genres):
                self.genres.tv = genres
                completion?(genres)
            case .failure(let error):
                print(error)
            }
            self.isTvGenresLoading = false
        }
    }
    
    func loadAllGenres(completion: (() -> Void)?) {
        let group = DispatchGroup()
        group.enter()
        loadTVGenres { _ in group.leave() }
        group.enter()
        loadMovieGenres { _ in group.leave() }
        group.notify(queue: .main) { completion?() }
    }
    
    func fetch<T>(url: URL?, completion: @escaping (Result<T, Error>) -> Void, loadGenres: MediaType! = nil) -> URLSessionTask? where T : Decodable {
        
        guard shouldFetchGenres(ofType: loadGenres)
        else { return fetch(url: url, completion: completion) }
        
        let group = DispatchGroup()
        
        group.notify(queue: .main) {
            self.fetch(url: url, completion: completion)
        }
        
        group.enter()
        switch loadGenres {
        case .movie:
            loadMovieGenres { _ in group.leave() }
        case .tvShow:
            loadTVGenres { _ in group.leave() }
        case .unknown:
            loadAllGenres { group.leave() }
        default:
            group.leave()
        }
        return nil
    }
}
