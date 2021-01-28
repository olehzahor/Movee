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

    var genres: Genres?
    var genresLoadingCompletionHandler: ((Genres) -> ())?
    
    static let shared = TMDBClient()
    
    func customList(page: Int, path: String, query: String, completion: @escaping PagedReusltCompletionHandler) -> URLSessionTask? {
        return fetch(url: Endpoints.shared.customList(page: page, path: path, params: query), completion: completion)
    }
    
    func discoverMovies(page: Int, filter: Filter, completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        guard let url = Endpoints.shared.discover(page: page, filter: filter)
        else { return nil }
        print(url)
        return fetch(url: url, completion: completion)
    }
    
    func getPersonDetails(personId: Int, completion: @escaping (Result<Person, Error>) -> Void) -> URLSessionTask? {
        return fetch(urlString: Endpoints.shared.personDetails(personId: personId), completion: completion)
    }
    
    func getRelatedMovies(movieId: Int, page: Int,  completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(urlString: Endpoints.shared.relatedMovies(
                        movieId: movieId,
                        page: page),
                     completion: completion)
    }
    
    func getPopularMovies(page: Int,
                          completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(urlString: Endpoints.shared.popularMovies(page: page),
              completion: completion)
    }
    
    func searchMovies(query: String, page: Int,
                      completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) -> URLSessionTask? {
        return fetch(urlString: Endpoints.shared.searchMovies(query: query, page: page),
              completion: completion)
    }
    
    func getGenresList(completion: @escaping (Result<Genres, Error>) -> Void) {
        let urlString = "https://api.themoviedb.org/3/genre/movie/list?api_key=\(key)&language=en-US"
        fetch(urlString: urlString, completion: completion)
    }
    
    func downloadPosterImage(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = Endpoints.shared.poster(path: path) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                completion(.success(data!))
            }
        }
        task.resume()
        
    }
    
    func getMovieDetails(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) -> URLSessionTask? {
        return fetch(url: Endpoints.shared.movieDetails(movieId: id),
              completion: completion)
    }
    
    func loadGenres(completion: ((Genres) -> ())? = nil) {
        print("fetching genres")
        getGenresList { (result) in
            switch result {
            case .success(let genres):
                self.genres = genres
                completion?(genres)
                //print("fetched genres")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override init() {
        super.init()
        //loadGenres()
    }
}



//    func getPopularMovies(page: Int, completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) {
//        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(key)&language=en-US&page=\(page)"
//        if genres == nil { fetchAndSaveGenres() }
//        fetch(urlString: urlString, completion: completion)
//    }
//
//    func getPopularMovies(page: Int, completion: @escaping (Result<MoviesPagedResult, Error>) -> Void) {
//        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(key)&language=en-US&page=\(page)"
//
//        guard genres != nil else {
//            fetch(urlString: urlString, completion: completion)
//            return
//        }
//
//        let group = DispatchGroup()
//
//        if genres == nil {
//            fetchAndSaveGenres(group: group)
//        }
//
//        group.enter()
//
//        var moviesResult: Result<MoviesPagedResult, Error>!
//        fetch(urlString: urlString) { (result: Result<MoviesPagedResult, Error>) in
//            moviesResult = result
//            group.leave()
//        }
//
//        group.notify(queue: .main) {
//            completion(moviesResult)
//        }
//    }
//
//    fileprivate func fetchAndSaveGenres() {
//        let semaphore = DispatchSemaphore(value: 0)
//        semaphore.wait()
//        getGenresList { result in
//            switch result {
//            case .success(let genres):
//                print("genres fetched!")
//                self.genres = genres
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//            semaphore.signal()
//        }
//    }
//
//
//    fileprivate func fetchAndSaveGenres(group: DispatchGroup) {
//        group.enter()
//        getGenresList { result in
//            switch result {
//            case .success(let genres):
//                self.genres = genres
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//            group.leave()
//        }
//    }

//    func getPopularMovies(pages: Int, completion: @escaping (Result<MoviesPagedResult, NetworkError>) -> Void) {
//        guard let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(key)&language=en-US&page=\(page)")
//        else { return }
//        print("fetching: \(url.absoluteString)")
//
//        let task = taskForGETRequest(url: url, responseType: MoviesPagedResult.self) { result in
//            switch result {
//
//            case .failure(let error):
//                completion(.failure(error))
//
//            case .success(let moviesResult):
//                if self.genres == nil {
//                    self.getGenresList { genresResult in
//                        switch genresResult {
//                        case .success(let genres):
//                            self.genres = genres
//                            completion(.success(moviesResult))
//                        case .failure(let error):
//                            print(error)
//                        }
//                    }
//                } else {
//                    completion(.success(moviesResult))
//                }
//            }
//        }
//        task.resume()
//    }
