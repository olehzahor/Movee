//
//  MoviesResult.swift
//  Movee
//
//  Created by jjurlits on 10/28/20.
//

import Foundation

struct MoviesPagedResult: Hashable, Codable {
    var results: [Movie]
    var total_results: Int
    var total_pages: Int
    var page: Int
}
