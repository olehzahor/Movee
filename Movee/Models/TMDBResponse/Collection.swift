//
//  Collection.swift
//  Movee
//
//  Created by jjurlits on 3/17/21.
//

import Foundation

struct Collection: SinglePageMediaListContainer {
    var medias: [AnyHashable] { return parts ?? [] }
    
    var id: Int?
    var name: String?
    var overview: String?
    var poster_path: String?
    var backdrop_path: String?
    var parts: [Movie]?
}
