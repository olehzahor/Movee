//
//  FilterCategory.swift
//  Movee
//
//  Created by jjurlits on 12/26/20.
//

import Foundation


protocol FilterCategory {
    var options: [MoviesFilterController.Option] { get }
    func pick(option: MoviesFilterController.Option)
    func update(filter: inout Filter)
    func reset()
}
