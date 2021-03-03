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

class TVShow: Media {
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
    
    var recommendations: TVShowsPagedResult?
    
    override var viewModel: MediaViewModel {
        return TVShowViewModel(tvShow: self)
    }

    enum CodingKeys: String, CodingKey {
        case title = "name", original_title = "original_name", release_date = "first_air_date"
        case episode_run_time, last_air_date, next_episode_to_air, in_production,
             status, networks, seasons, recommendations
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try? container.decode(String.self, forKey: .title)
        original_title = try? container.decode(String.self, forKey: .original_title)
        release_date = try? container.decode(String.self, forKey: .release_date)
        
        episode_run_time = try? container.decode([Int].self, forKey: .episode_run_time)
        last_air_date = try? container.decode(String.self, forKey: .last_air_date)
        next_episode_to_air = try? container.decode(Episode.self, forKey: .next_episode_to_air)
        in_production = try? container.decode(Bool.self, forKey: .in_production)
        status = try? container.decode(String.self, forKey: .status)
        networks = try? container.decode([Network].self, forKey: .networks)
        seasons = try? container.decode([Season].self, forKey: .seasons)
        recommendations = try? container.decode(TVShowsPagedResult.self, forKey: .recommendations)
        
      }
    
    required init() {
        super.init()
    }
}



struct TVShowsPagedResult: Hashable, Codable {
    var results: [TVShow]
    var total_results: Int
    var total_pages: Int
    var page: Int
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
