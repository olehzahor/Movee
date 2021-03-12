//
//  PagedResult.swift
//  Movee
//
//  Created by jjurlits on 3/11/21.
//

import Foundation

struct PagedResult<T: MediaListItem>: Hashable, Codable {
    var results: [T]
    var total_results: Int
    var total_pages: Int
    var page: Int
}
