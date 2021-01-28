//
//  Movie.swift
//  Movee
//
//  Created by jjurlits on 10/27/20.
//

import Foundation

struct Movie: Codable, Hashable, Equatable {
    // short response
    var id: Int?

    var title: String?
    var poster_path: String?
    var adult: Bool?
    var overview: String?
    var release_date: String?
    var genre_ids: [Int]?
    var original_title: String?
    var original_language: String?
    var backdrop_path: String?
    var popularity: Double?
    var vote_count: Int?
    var video: Bool?
    var vote_average: Double?
    
    // detailed response
    var credits: Credits?
    var genres: [Genre]?
    var runtime: Int?
    var recommendations: MoviesPagedResult?
    var production_countries: [Country]?
    var revenue: Double?
    var budget: Double?
    
    // credits response
    var character: String?
    var credit_id: String?
    var department: String?
    var job: String?
    
    var videos: Video?
    
    var isPosterAvaiable: Bool {
        return poster_path != nil
    }
    
    static var placeholder: Movie {
        return Movie()
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
    static func dateFromDateString(_ dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        return formatter.date(from: dateString)
    }
}

extension Movie {
    var short: Movie {
        var movie = Movie()
        movie.id = id
        movie.release_date = release_date
        movie.title = title
        movie.original_title = original_title
        movie.overview = overview
        movie.poster_path = poster_path
        movie.vote_average = vote_average
        movie.vote_count = vote_count
        movie.genre_ids = genre_ids
        movie.genres = genres
        movie.backdrop_path = backdrop_path
        movie.popularity = popularity
        
        return movie
    }
}

//extension Movie: Hashable, Equatable {
////    func hash(into hasher: inout Hasher) {
////        hasher.combine(id)
////    }
////
////    static func == (lhs: Movie, rhs: Movie) -> Bool {
////        return lhs.id == rhs.id
////    }
//}
