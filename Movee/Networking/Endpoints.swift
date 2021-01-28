//
//  Endpoints.swift
//  Movee
//
//  Created by jjurlits on 11/18/20.
//

import Foundation

struct Endpoints {
    static let shared = Endpoints()
    let locale: String
    
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: locale)
        ]
        return components
    }
    
    private let apiKey: String
    private let baseURL = "https://api.themoviedb.org/3/"
    private var postfix: String {
        return "api_key=\(apiKey)&language=\(locale)"
    }
    
    func customList(page: Int, path: String, params: String) -> URL? {
        var components = self.baseComponents
        components.path = "/3/\(path)"
        components.query! += "&\(params)&page=\(page)"
        return components.url
    }
    
    func movieDetails(movieId: Int) -> URL? {
        var components = self.baseComponents
        components.path = "/3/movie/\(movieId)"
        components.queryItems?.append(
            .init(name: "append_to_response",
                  value: "credits,recommendations,videos"))
        return components.url
    }
    
    func discover(page: Int = 1, filter: Filter) -> URL? {
        var components = self.baseComponents
        components.path = "/3/discover/movie"
        components.queryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
        components.queryItems?.append(contentsOf: filter.queryItems)
        return components.url
    }
    
    func personDetails(personId: Int) -> String {
        return baseURL +
            "person/\(personId)?&append_to_response=movie_credits&\(postfix)"
    }
    
    func relatedMovies(movieId: Int, page: Int = 1) -> String {
        return baseURL +
            "movie/\(movieId)/recommendations?api_key=\(apiKey)&language=\(locale)&page=\(page)"
    }
    
    func popularMovies(page: Int = 1) -> String {
        return baseURL +
            "movie/popular?api_key=\(apiKey)&language=\(locale)&page=\(page)"
    }
    
    func searchMovies(query: String, page: Int = 1) -> String {
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return baseURL +
            "search/movie?api_key=\(apiKey)&language=\(locale)&page=\(page)&include_adult=false&query=\(encodedQuery)"
    }
    
    func poster(path: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "image.tmdb.org"
        components.path = "/t/p/w500\(path)"
        components.queryItems?.append(
            URLQueryItem(name: "language", value: self.locale))
        components.queryItems?.append(
            URLQueryItem(name: "include_image_language", value: "en,null"))
        return components.url
    }
    
    private init(apiKey key: String, locale: String) {
        self.apiKey = key
        self.locale = locale
    }
    
    private init() {
        self.apiKey = "d65446acbb59f68418c9bf8dc9347056"
        self.locale = "ru-RU"
    }
    
}
