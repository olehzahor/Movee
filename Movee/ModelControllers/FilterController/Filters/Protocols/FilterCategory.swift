//
//  FilterCategory.swift
//  Movee
//
//  Created by jjurlits on 12/26/20.
//

import Foundation


protocol FilterCategory {
    var options: [FilterController.Option] { get }
    func pick(option: FilterController.Option)
    func update(filter: inout Filter)
    func reset()
}


//protocol FilterCategory {
//    var _options: [AnyHashable] { get }
//    var selectedOptions: [AnyHashable] { get }
//
//    var options: [FilterController.Option] { get }
//    func pick(option: FilterController.Option)
//    func state(option: AnyHashable) -> FilterController.Option.State
//    func update(filter: inout Filter)
//}

//protocol FilterCategory {
//    associatedtype T: Hashable
//
//    var _options: [T] { get }
//    var selectedOptions: [T] { get }
//
//    var options: [FilterController.Option] { get }
//
//    func pick(option: FilterController.Option)
//    func state(option: T) -> FilterController.Option.State
//    func update(filter: inout Filter)
//}
