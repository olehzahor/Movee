//
//  TMDBClient.swift
//  Movee
//
//  Created by jjurlits on 10/27/20.
//

import Foundation

class TMDBClient: ApiService {
    struct StoredGenres {
        var movie: Genres?
        var tv: Genres?
    }
        
    typealias PagedReusltCompletionHandler = (Result<MoviesPagedResult, Error>) -> Void
    var locale: String = "en_US"
    
    lazy var endpoints = Endpoints(apiKey: TMDB_API_KEY, locale: locale)

    var genres: StoredGenres = StoredGenres()
    private var isMovieGenresLoading = false
    private var isTvGenresLoading = false
    
    //var genresLoadingCompletionHandler: ((Genres) -> ())?
    
    static let shared = TMDBClient()
    
//    func customList(page: Int, path: String, query: String, completion: @escaping PagedReusltCompletionHandler) -> URLSessionTask? {
//        return fetch(url: endpoints.customList(page: page, path: path, params: query), completion: completion)
//    }
    
    func customList<MediaType: Media>(page: Int, path: String, query: String, completion: @escaping (Result<MediaPagedResult<MediaType>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.customList(page: page, path: path, params: query), completion: completion)
    }

    
    func discoverMovies(page: Int, filter: Filter, completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        guard let url = endpoints.discover(page: page, filter: filter)
        else { return nil }
        //print(url)
        return fetch(url: url, completion: completion)
    }
    
    func getPersonDetails(personId: Int, completion: @escaping (Result<Person, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.personDetails(personId: personId), completion: completion)
    }
    
    func getRelatedMovies(movieId: Int, page: Int,  completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.relatedMovies(movieId: movieId, page: page),
                     completion: completion)
    }
    
    func getPopularMovies(page: Int,
                          completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.popularMovies(page: page),
                     completion: completion)
    }
    
    func getPopularMovies<T>(page: Int,
                          completion: @escaping (Result<AnyMediaPagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.popularMovies(page: page),
                     completion: completion)
    }

    
    func getPopularTVShows(page: Int,
                          completion: @escaping (Result<MediaPagedResult<Media>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.popularTVShows(page: page),
                     completion: completion)
    }

    func searchMovies<T: Media>(query: String, page: Int,
                      completion: @escaping (Result<MediaPagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchMovies(query: query, page: page),
              completion: completion)
    }

    
    func searchMovies(query: String, page: Int,
                      completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchMovies(query: query, page: page),
              completion: completion)
    }

    
    func searchMovies(query: String, page: Int,
                      completion: @escaping (Result<PagedSearchResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchMovies(query: query, page: page),
              completion: completion)
    }
    
    func searchMovies<T>(query: String, page: Int,
                      completion: @escaping (Result<AnyMediaPagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchMovies(query: query, page: page),
              completion: completion)
    }

    
    func searchTVShows(query: String, page: Int,
                       completion: @escaping (Result<MediaPagedResult<TVShow>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchTVShows(query: query, page: page),
              completion: completion)
    }
    
    func searchTVShows<T: TMDBMediaResponse>(query: String, page: Int,
                       completion: @escaping (Result<AnyMediaPagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchTVShows(query: query, page: page),
              completion: completion)
    }


    
    func searchTVShows(query: String, page: Int,
                       completion: @escaping (Result<PagedSearchResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchTVShows(query: query, page: page),
              completion: completion)
    }


    
    func searchPeople(query: String, page: Int,
                      completion: @escaping (Result<PagedSearchResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchPeople(query: query, page: page),
              completion: completion)
    }
    
    func searchPeople<T>(query: String, page: Int,
                      completion: @escaping (Result<AnyMediaPagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchPeople(query: query, page: page),
              completion: completion)
    }

    
    func searchMulti(query: String, page: Int,
                      completion: @escaping (Result<PagedSearchResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchMulti(query: query, page: page),
              completion: completion)
    }
    
    func searchMulti<T: Media>(query: String, page: Int,
                      completion: @escaping (Result<MediaPagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchMulti(query: query, page: page),
              completion: completion)
    }
    
    func searchMulti<T>(query: String, page: Int,
                      completion: @escaping (Result<AnyMediaPagedResult<T>, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchMulti(query: query, page: page),
              completion: completion)
    }



    
    func getMovieGenresList(completion: @escaping (Result<Genres, Error>) -> Void) {
        guard let url = endpoints.movieGenresList() else { return }
        fetch(url: url, completion: completion)
        
    }
    
    func getTvGenresList(completion: @escaping (Result<Genres, Error>) -> Void) {
        guard let url = endpoints.tvGenresList() else { return }
        fetch(url: url, completion: completion)
        
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

    
//    func loadGenres(completion: ((Genres) -> ())? = nil) {
//        getGenresList { (result) in
//            switch result {
//            case .success(let genres):
//                self.genres = genres
//                completion?(genres)
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
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

