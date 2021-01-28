//
//  Genre.swift
//  Movee
//
//  Created by jjurlits on 10/28/20.
//

import Foundation

struct Genres: Hashable, Codable {
    let genres: [Genre]
    
    func name(for id: Int) -> String {
        return genres.first(where: {$0.id == id})?.name ?? ""
    }
    
    func string(from genres: [Int]?) -> String {
        guard let genres = genres else {
            return ""
        }
        
        return genres.compactMap({name(for: $0)}).joined(separator: "・")
    }
}

struct Genre: Hashable, Codable {
    let id: Int
    let name: String
}
