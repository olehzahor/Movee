//
//  Media.swift
//  Movee
//
//  Created by jjurlits on 3/1/21.
//

import Foundation

class MultiSearchResult: Media {
    enum CodingKeys: String, CodingKey {
        case title, release_date, name, first_air_date
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try? container.decode(String.self, forKey: .title)
        
        if title == nil {
            title = try? container.decode(String.self, forKey: .name)
        }
        
        release_date = try? container.decode(String.self, forKey: .release_date)
    }
    
    required init() {
        super.init()
    }

}

class Media: Hashable, Codable {
    enum MediaType { case movie, tv, unknown }

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
//
//    static var placeholder: Media {
//        return MediaPlaceholder()
//    }
    
    static func == (lhs: Media, rhs: Media) -> Bool {
        lhs.id == rhs.id && lhs.title == rhs.title
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
    }

    
    static func placeholder<T: Media>() -> T {
        T()
    }
    
    
    var viewModel: MediaViewModel {
        return AnyMediaViewModel(media: self)
    }
    
    required init() { }
}

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

