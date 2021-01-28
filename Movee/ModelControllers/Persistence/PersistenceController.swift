//
//  PersistenceController.swift
//  Movee
//
//  Created by jjurlits on 1/24/21.
//

import Foundation

protocol PersistenceController {
    associatedtype ItemType: Codable&Hashable
    var items: [ItemType] { get set }
    var filename: String { get set }
    func addItem(_ item: ItemType)
    func removeItem(_ item: ItemType)
    func loadData()
    func saveData()
}
