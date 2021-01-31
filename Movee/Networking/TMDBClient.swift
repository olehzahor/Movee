//
//  TMDBClient.swift
//  Movee
//
//  Created by jjurlits on 10/27/20.
//

import Foundation

class TMDBClient: ApiService {
    typealias PagedReusltCompletionHandler = (Result<MoviesPagedResult, Error>) -> Void
    
    let key = "d65446acbb59f68418c9bf8dc9347056"
    var locale: String = "en_US"
    
    lazy var endpoints = Endpoints(apiKey: key, locale: locale)

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
        return fetch(urlString: endpoints.personDetails(personId: personId), completion: completion)
    }
    
    func getRelatedMovies(movieId: Int, page: Int,  completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(urlString: endpoints.relatedMovies(
                        movieId: movieId,
                        page: page),
                     completion: completion)
    }
    
    func getPopularMovies(page: Int,
                          completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(urlString: endpoints.popularMovies(page: page),
              completion: completion)
    }
    
    func searchMovies(query: String, page: Int,
                      completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(urlString: endpoints.searchMovies(query: query, page: page),
              completion: completion)
    }
    
    func getGenresList(completion: @escaping (Result<Genres, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(key)&language=en-US"
        fetch(urlString: urlString, completion: completion)
    }
    
//    func downloadPosterImage(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
//        guard let url = endpoints.image(path: path: path) else { return }
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            DispatchQueue.main.async {
//                completion(.success(data!))
//            }
//        }
//        task.resume()
//
//    }
//
    func getMovieDetails(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: endpoints.movieDetails(movieId: id),
              completion: completion)
    }
    
    func loadGenres(completion: ((Genres) -> ())? = nil) {
        print("fetching genres")
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
