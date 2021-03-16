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

struct TVShow: Media {
    
    var id: Int?
    var title: String?
    var original_title: String?
    var release_date: String?
    var poster_path: String?
    var backdrop_path: String?
    var popularity: Double?
    var vote_count: Int?
    var vote_average: Double?
    var overview: String?
    var genre_ids: [Int]?
    var media_type: String?
    var adult: Bool?
    var genres: [Genre]?
    var credits: Credits?
    var production_countries: [Country]?
    var original_language: String?
    var tagline: String?
    var videos: Video?
    var reviews: PagedResult<Review>?

    
    static var placeholder = TVShow()

    var name: String?
    var first_air_date: String?

    
    var original_name: String?
    
    var episode_run_time: [Int]?

    var last_air_date: String?
    var next_episode_to_air: Episode?
    
    var in_production: Bool?
    var status: String?

    var networks: [Network]?
    var seasons: [Season]?
    
    var recommendations: PagedResult<TVShow>?
    
    enum CodingKeys: String, CodingKey {
        case title = "name", original_title = "original_name", release_date = "first_air_date"
        case id, poster_path, backdrop_path, popularity, vote_count, vote_average, overview, genre_ids, media_type, adult, genres, credits, production_countries, original_language, tagline, videos, episode_run_time, last_air_date, next_episode_to_air, in_production, status, networks, seasons, recommendations, reviews
    }
}

extension TVShow {
    var mediaType: MediaType { return .tvShow }
    var viewModel: MediaViewModel {
        return TVShowViewModel(tvShow: self)
    }
}

extension TVShow {
    var short: TVShow {
        var tvShow = TVShow()
        tvShow.id = id
        tvShow.release_date = release_date
        tvShow.title = title
        tvShow.original_title = original_title
        tvShow.overview = overview
        tvShow.poster_path = poster_path
        tvShow.vote_average = vote_average
        tvShow.vote_count = vote_count
        tvShow.genre_ids = genre_ids
        tvShow.genres = genres
        tvShow.backdrop_path = backdrop_path
        tvShow.popularity = popularity

        return tvShow
    }
}

struct Network: Codable, Hashable {
    var name: String
    var id: Int?
    var logo_path: String?
    var origin_country: String?
}

struct Season: Codable, Hashable {
    var id: Int?
    var overview: String?
    var air_date: String?
    var episode_count: Int?
    var season_number: Int?
    var name: String?
    var poster_path: String?
    var episodes: [Episode]?

    /*
    air_date    string    optional
    episode_count    integer    optional
    id    integer    optional
    name    string    optional
    overview    string    optional
    poster_path    string    optional
    season_number    integer */
}

struct Episode: Codable, Hashable {
    var name: String?
    var overview: String?
    var still_path: String?
    var air_date: String?
    var episode_number: Int?
    var season_number: Int?
    var vote_average: Double?
    var vote_count: Int?
    
    /*
     
     air_date     string     optional
     episode_number     integer     optional
     id     integer     optional
     name     string     optional
     overview     string     optional
     production_code     string     optional
     season_number     integer     optional
     still_path     string or null     optional
     vote_average     number     optional
     vote_count     integer     optional
     */
}

//struct TVShow3: Codable, Hashable, Equatable {
//    var release_date: String?
//
//    var title: String?
//    // short response
//    var id: Int?
//
//    var name: String = ""
//    var original_name: String?
//    var poster_path: String?
//    var backdrop_path: String?
//    var adult: Bool?
//    var overview: String?
//    var first_air_date: String?
//    var last_air_date: String?
//
//    var media_type: String?
//
//    var genre_ids: [Int]?
//    var original_language: String?
//    var popularity: Double?
//    var vote_count: Int?
//    var vote_average: Double?
//    var genres: [Genre]?
//    var episode_run_time: [Int]?
//
//    var next_episode_to_air: Episode?
//
//    var in_production: Bool?
//    var status: String?
//    var production_countries: [Country]?
//
//    var credits: Credits?
//    var networks: [Network]?
//    var seasons: [Season]?
//    var videos: Video?
//    var tagline: String?
//
//    var recommendations: TVShowsPagedResult?
//
//    static var placeholder = TVShow3()
//
//    enum CodingKeys: String, CodingKey {
//        case title = "name"
//        case release_date = "first_air_date"
//        case id, media_type, poster_path, backdrop_path, popularity, vote_count, vote_average, adult, overview, genre_ids, genres, credits, production_countries, original_language, tagline, videos
//    }
//}
