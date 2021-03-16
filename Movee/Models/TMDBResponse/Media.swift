//
//  Media.swift
//  Movee
//
//  Created by jjurlits on 3/1/21.
//

import Foundation

enum MediaType: String, Codable {
    case movie, tvShow, unknown
}

protocol Media: MediaListItem {
    var mediaType: MediaType { get }
    
    var id: Int? { get set }

    var title: String? { get set }
    var original_title: String? { get set }
    var release_date: String? { get set }

    var poster_path: String? { get set }
    var backdrop_path: String? { get set }
    var popularity: Double? { get set }
    var vote_count: Int? { get set }
    var vote_average: Double? { get set }
    var overview: String? { get set }
    var genre_ids: [Int]? { get set }
    
    var media_type: String? { get set }
    var adult: Bool? { get set }
    var genres: [Genre]? { get set }
    var credits: Credits? { get set }
    var production_countries: [Country]? { get set }
    var original_language: String? { get set }
    var tagline: String? { get set }
    var videos: Video? { get set }
    var reviews: PagedResult<Review>? { get set }
}

struct Review: MediaListItem {
    static var placeholder: Review = Review()
    var id: String?
    var author: String?
    var updated_at: String?
    var content: String?
    var url: String?
}

struct MediaPlaceholder: MediaListItem {
    static var placeholder = MediaPlaceholder(id: nil)
    var id: Int?
}

extension Media {
    var viewModel: MediaViewModel {
        return AnyMediaViewModel(media: self)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
}

//class Media: Hashable, Codable {
//    enum MediaType { case movie, tv, unknown }
//
//    var id: Int?
//
//    var title: String?
//    var original_title: String?
//    var release_date: String?
//
//    var poster_path: String?
//    var backdrop_path: String?
//    var popularity: Double?
//    var vote_count: Int?
//    var vote_average: Double?
//    var overview: String?
//    var genre_ids: [Int]?
//
//    var media_type: String?
//    var adult: Bool?
//    var genres: [Genre]?
//    var credits: Credits?
//    var production_countries: [Country]?
//    var original_language: String?
//    var tagline: String?
//    var videos: Video?
////
////    static var placeholder: Media {
////        return MediaPlaceholder()
////    }
//
//    static func == (lhs: Media, rhs: Media) -> Bool {
//        lhs.id == rhs.id && lhs.title == rhs.title
//    }
//
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(id)
//        hasher.combine(title)
//    }
//
//
//    static func placeholder<T: Media>() -> T {
//        T()
//    }
//
//
//    var viewModel: MediaViewModel {
//        return AnyMediaViewModel(media: self)
//    }
//
//    required init() { }
//}

//class MediaPlaceholder: Media {
//    required init() {
//        super.init()
//        self.id = -1
//    }
//
//    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
//    }
//}

//protocol Media: Codable, Hashable {
//    var id: Int? { get }
//    var media_type: String? { get }
//    var title: String? { get }
//    var release_date: String? { get }
//    var poster_path: String? { get }
//    var backdrop_path: String? { get }
//    var popularity: Double? { get }
//    var vote_count: Int? { get }
//    var vote_average: Double? { get }
//    var adult: Bool? { get }
//    var overview: String? { get }
//    var genre_ids: [Int]? { get }
//    var genres: [Genre]? { get }
//    var credits: Credits? { get }
//    var production_countries: [Country]? { get }
//    var original_language: String? { get }
//    var tagline: String? { get }
//    var videos: Video? { get }
//    //static var placeholder: Self { get }
//}

