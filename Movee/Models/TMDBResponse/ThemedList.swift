//
//  ThemedList.swift
//  Movee
//
//  Created by jjurlits on 3/17/21.
//

import Foundation

struct ThemedList: SinglePageMediaListContainer {
    var medias: [AnyHashable] { return items ?? [] }
    
    var created_by: String?
    var description: String?
    var favorite_count: Int?
    var id: String?
    var items: [Movie]?
    var item_count: Int?
    var iso_639_1: String?
    var name: String?
    var poster_path: String?
}
