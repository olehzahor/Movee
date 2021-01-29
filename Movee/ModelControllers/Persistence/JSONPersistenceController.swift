//
//  JSONPersistenceController.swift
//  Movee
//
//  Created by jjurlits on 1/24/21.
//

import Foundation

class JSONPersistenceController<T: Codable&Hashable>: PersistenceController {
    lazy private var encoder = JSONEncoder()
    lazy private var decoder = JSONDecoder()
    
    private(set) var isDataLoaded: Bool = false

    var filename: String = ""
    var items = [T]()
    
    func addItem(_ item: T) {
        items.append(item)
        saveData()
    }
    
    func removeItem(_ item: T) {
        items.removeAll { $0 == item }
        saveData()
    }
    
    
    internal func loadData() {
        if let savedItems = Data.load(fromFile: filename) {
            if let loadedItems = try? decoder.decode([ItemType].self, from: savedItems) {
                self.items = loadedItems
                isDataLoaded = true
            }
        }
    }
    
    internal func saveData() {
        if let encoded = try? encoder.encode(items) {
            encoded.save(toFile: filename)
        }
    }
    
    init(filename: String) {
        self.filename = filename
    }
}
