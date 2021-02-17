//
//  TMDBClient.swift
//  Movee
//
//  Created by jjurlits on 10/27/20.
//

import Foundation

class TMDBClient: ApiService {
    typealias PagedReusltCompletionHandler = (Result<MoviesPagedResult, Error>) -> Void
    var locale: String = "en_US"
    
    lazy var endpoints = Endpoints(apiKey: TMDB_API_KEY, locale: locale)

    var genres: Genres?
    var genresLoadingCompletionHandler: ((Genres) -> ())?
    
    static let shared = TMDBClient()
    
    func customList(page: Int, path: String, query: String, completion: @escaping PagedReusltCompletionHandler) -> URLSessionTask? {
        return fetch(url: endpoints.customList(page: page, path: path, params: query), completion: completion)
    }
    
    func discoverMovies(page: Int, filter: Filter, completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        guard let url = endpoints.discover(page: page, filter: filter)
        else { return nil }
        print(url)
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
    
    func searchMovies(query: String, page: Int,
                      completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchMovies(query: query, page: page),
              completion: completion)
    }
    
    func searchPeople(query: String, page: Int,
                      completion: @escaping (Result<PeoplePagedResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.searchPeople(query: query, page: page),
              completion: completion)
    }
    
    func getGenresList(completion: @escaping (Result<Genres, Error>) -> Void) {
        guard let url = endpoints.genresList() else { return }
        fetch(url: url, completion: completion)
        
    }
    
    func getMovieDetails(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.movieDetails(movieId: id),
              completion: completion)
    }
    
    func loadGenres(completion: ((Genres) -> ())? = nil) {
        getGenresList { (result) in
            switch result {
            case .success(let genres):
                self.genres = genres
                completion?(genres)
            case .failure(let error):
                print(error)
            }
        }
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

