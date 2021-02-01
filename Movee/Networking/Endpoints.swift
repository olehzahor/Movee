//
//  Endpoints.swift
//  Movee
//
//  Created by jjurlits on 11/18/20.
//

import Foundation

struct Endpoints {
    private let locale: String
    private let apiKey: String
    
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
    
    private func queryItem(forPage page: Int) -> URLQueryItem {
        URLQueryItem(name: "page", value: "\(page)")
    }
    
    private func constructURL(path: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        var components = baseComponents
        components.path = path
        components.queryItems?.append(contentsOf: queryItems ?? [])
        return components.url
    }
    
    func genresList() -> URL? {
        return constructURL(path: "/3/genre/movie/list")
    }
    
    func movieDetails(movieId: Int) -> URL? {
        let queryItems = URLQueryItem(
            name: "append_to_response",
            value: "credits,recommendations,videos")
        
        return constructURL(
            path: "/3/movie/\(movieId)",
            queryItems: [queryItems])
    }
    
    func discover(page: Int = 1, filter: Filter) -> URL? {
        var queryItems = filter.queryItems
        queryItems.append(queryItem(forPage: page))
        
        return constructURL(path: "/3/discover/movie",
                            queryItems: queryItems)
    }
    
    func customList(page: Int, path: String, params: String) -> URL? {
        var components = self.baseComponents
        components.path = "/3/\(path)"
        components.query! += "&\(params)&page=\(page)"
        return components.url
    }
    
    func personDetails(personId: Int) -> URL? {
        let queryItem = URLQueryItem(name: "append_to_response", value: "movie_credits")
        return constructURL(path: "/3/person/\(personId)", queryItems: [queryItem])
    }
    
    func relatedMovies(movieId: Int, page: Int = 1) -> URL?  {
        return constructURL(path: "/3/movie/\(movieId)/recommendations",
                            queryItems: [queryItem(forPage: page)])
    }
    
    func popularMovies(page: Int = 1) -> URL? {
        return constructURL(path: "/3/movie/popular",
                            queryItems: [queryItem(forPage: page)])
    }

    func searchMovies(query: String, page: Int = 1) -> URL? {
        let queryItems = [
            URLQueryItem(name: "include_adult", value: "false"),
            URLQueryItem(name: "query", value: query),
            queryItem(forPage: page) ]
        
        let url = constructURL(path: "/3/search/movie", queryItems: queryItems)
        return url
    }
    
    func image(path: String, size: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "image.tmdb.org"
        components.path = "/t/p/\(size)\(path)"
        components.queryItems?.append(
            URLQueryItem(name: "language", value: self.locale))
        components.queryItems?.append(
            URLQueryItem(name: "include_image_language", value: "en,null"))
        return components.url
    }

    init(apiKey key: String, locale: String) {
        self.apiKey = key
        self.locale = locale
    }
}
