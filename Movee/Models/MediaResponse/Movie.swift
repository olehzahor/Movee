//
//  Movie.swift
//  Movee
//
//  Created by jjurlits on 10/27/20.
//

import Foundation

class Movie: Media {
    var video: Bool?
    
    // detailed response
    var runtime: Int?
    var recommendations: MoviesPagedResult?
    var revenue: Double?
    var budget: Double?
    
    // credits response
    var character: String?
    var credit_id: String?
    var department: String?
    var job: String?
        
    var isPosterAvaiable: Bool {
        return poster_path != nil
    }
    
    override var viewModel: MediaViewModel {
        return MovieViewModel(movie: self)
    }
    
    enum CodingKeys: String, CodingKey {
        case video, runtime, recommendations, revenue, budget,
             character, credit_id, department, job
    }
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        video = try? container.decode(Bool.self, forKey: .video)
        runtime = try? container.decode(Int.self, forKey: .runtime)
        recommendations = try? container.decode(MoviesPagedResult.self, forKey: .recommendations)
        revenue = try? container.decode(Double.self, forKey: .revenue)
        budget = try? container.decode(Double.self, forKey: .budget)
        
        character = try? container.decode(String.self, forKey: .character)
        credit_id = try? container.decode(String.self, forKey: .credit_id)
        department = try? container.decode(String.self, forKey: .department)
        job = try? container.decode(String.self, forKey: .job)
    }
}

struct Video: Codable, Hashable, Equatable {
    var id: Int?
    var results: [VideoResult]?
}

struct VideoResult: Codable, Hashable, Equatable {
    var id: String?
    var key: String?
    var name: String?
    var site: String?
    var type: String?
    var size: Int?
}

struct Country: Codable, Hashable, Equatable {
    var iso_3166_1: String?
    var name: String?
}

extension Movie {
    var short: Movie {
        return self
//        var movie = Movie()
//        movie.id = id
////        movie.release_date = release_date
////        movie.title = title
//        movie.original_title = original_title
//        movie.overview = overview
//        movie.poster_path = poster_path
//        movie.vote_average = vote_average
//        movie.vote_count = vote_count
//        movie.genre_ids = genre_ids
//        movie.genres = genres
//        movie.backdrop_path = backdrop_path
//        movie.popularity = popularity
//
//        return movie
    }
}


//struct Movie3: Codable, Hashable, Equatable {
//    var title: String?
//    
//    static var placeholder = Movie()
//    
//    // short response
//    var id: Int?
//
//    //var title: String = ""
//    var poster_path: String?
//    var adult: Bool?
//    var overview: String?
//    var release_date: String?
//    var genre_ids: [Int]?
//    var original_title: String?
//    var original_language: String?
//    var backdrop_path: String?
//    var popularity: Double?
//    var vote_count: Int?
//    var video: Bool?
//    var vote_average: Double?
//
//    
//    // detailed response
//    var credits: Credits?
//    var genres: [Genre]?
//    var runtime: Int?
//    var recommendations: MoviesPagedResult?
//    var production_countries: [Country]?
//    var revenue: Double?
//    var budget: Double?
//    var tagline: String?
//    
//    // credits response
//    var character: String?
//    var credit_id: String?
//    var department: String?
//    var job: String?
//    
//    var videos: Video?
//    var media_type: String?
//    
//    var isPosterAvaiable: Bool {
//        return poster_path != nil
//    }
//}
//
