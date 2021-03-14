//
//  Filter.swift
//  Movee
//
//  Created by jjurlits on 12/14/20.
//

import Foundation

struct Filter: Codable {
    struct Range<T: Codable>: Codable {
        var min: T?
        var max: T?
    }
    
    enum SortBy: String, Codable {
        case popularityAscending = "popularity.asc"
        case popularityDescending = "popularity.desc"
        case releaseDateAscending = "release_date.asc"
        case releaseDateDescending = "release_date.desc"
        case revenueAscending = "revenue.asc"
        case revenueDescending = "revenue.desc"
        case primaryReleaseDateAscending = "primary_release_date.asc"
        case primaryReleaseDateDescending = "primary_release_date.desc"
        case originalTitleAscending = "original_title.asc"
        case originalTitleDescending = "original_title.desc"
        case voteAverageAscending = "vote_average.asc"
        case voteAverageDescending = "vote_average.desc"
        case voteCountAscending = "vote_count.asc"
        case voteCountDescending = "vote_count.desc"
    }

    var region: String?
    var sortBy: SortBy = .popularityDescending
    var includeAdult: Bool?
    var includeVideo: Bool?
    var primaryReleaseYear: Int?
    var withReleaseType: Int?
    var year: Int?
    var withCast: [String]? = []
    var withCrew: [String]? = []
    var withPeople: [String]? = []
    var withCompanies: [String]? = []
    var withGenres: [Int]? = []
    var withoutGenres: [Int]? = []
    var withKeywords: [String]? = []
    var withoutKeywords: [String]? = []
    var withOriginalLanguage: String?
    
    var primaryReleaseDate: ClosedRange<Date>?
    var releaseDate: ClosedRange<Date>?
    
    var votes = Range<Int>()
    var rating = Range<Int>()
    var runtime = Range<Int>()
    
    func string(_ value: Any?) -> String? {
        guard let value = value else { return nil }
        return "\(value)"
    }
    
    func string(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func string(_ array: [String]?) -> String? {
        guard let array = array else { return nil }
        return array.joined(separator: ",")
    }
    
    func string(_ array: [Int]?) -> String? {
        guard let array = array else { return nil }
        return array.compactMap({"\($0)"}).joined(separator: ",")
    }
    
    private var parameters: [String: String?] {
        return [
            "region": string(region),
            "sort_by": string(sortBy.rawValue),
            "include_adult": string(includeAdult),
            "include_video": string(includeVideo),
            "primary_release_year": string(primaryReleaseYear),
            "with_release_type": string(withReleaseType),
            "year": string(year),
            "with_cast": string(withCast),
            "with_crew": string(withCrew),
            "with_people": string(withPeople),
            "with_companies": string(withCompanies),
            "with_genres": string(withGenres),
            "without_genres": string(withoutGenres),
            "with_keywords": string(withKeywords),
            "without_keywords": string(withoutKeywords),
            "with_original_language": string(withOriginalLanguage),
            "primary_release_date.gte": string(primaryReleaseDate?.lowerBound),
            "primary_release_date.lte": string(primaryReleaseDate?.upperBound),
            "release_date.gte": string(releaseDate?.lowerBound),
            "release_date.lte": string(releaseDate?.upperBound),
            "vote_count.gte": string(votes.min),
            "vote_count.lte": string(votes.max),
            "vote_average.gte": string(rating.min),
            "vote_average.lte": string(rating.max),
            "with_runtime.gte": string(runtime.min),
            "with_runtime.lte": string(runtime.max)
        ].filter { $0.value != nil }
    }
    
    var queryItems: [URLQueryItem] {
        return parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    init() { }
}
