//
//  TVShow.swift
//  Movee
//
//  Created by jjurlits on 2/18/21.
//

import Foundation

//poster_path string
//popularity number
//id integer
//backdrop_path string or null
//vote_average number
//overview string
//first_air_date string
//origin_country array[string]
//genre_ids array[integer]
//original_language string
//vote_count integer
//name string
//original_name string

struct TVShow: Codable, Hashable, Equatable {
    // short response
    var id: Int?

    var name: String = ""
    var original_name: String?
    var poster_path: String?
    var backdrop_path: String?
    var adult: Bool?
    var overview: String?
    var first_air_date: String?
    var genre_ids: [Int]?
    var original_language: String?
    var popularity: Double?
    var vote_count: Int?
    var vote_average: Double?

    static var placeholder = TVShow()
}

extension TVShow {
    func transformToMovie() -> Movie {
        var movie = Movie()
        
        movie.title = name
        movie.original_title = original_name
        movie.release_date = first_air_date
        
        movie.media_type = "tv"
        
        movie.poster_path = poster_path
        movie.backdrop_path = backdrop_path
        movie.adult = adult
        movie.overview = overview
        movie.genre_ids = genre_ids
        
        return movie
    }
}
