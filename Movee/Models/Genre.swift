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
    
    func strings(from ids: [Int]?) -> [String] {
        guard let ids = ids else { return [] }
        return ids.compactMap({name(for: $0)})
    }
}

struct Genre: Hashable, Codable {
    let id: Int
    let name: String
}
