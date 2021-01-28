//
//  Coordinated.swift
//  Movee
//
//  Created by jjurlits on 1/10/21.
//

import Foundation

protocol Coordinated: class {
    associatedtype CoordinatorType: Coordinator
    var coordinator: CoordinatorType? { get set }
}
