//
//  MovieContainer.swift
//  Movee
//
//  Created by jjurlits on 1/4/21.
//

import Foundation

struct MovieContainer: Hashable {
    var id: Int
    var index: Int?
    var page: Int?
    var movie: Movie?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
