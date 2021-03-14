//
//  rename-later.swift
//  Movee
//
//  Created by jjurlits on 3/14/21.
//

import Foundation

class AsyncJSONPersistenceController<T: Codable&Hashable>: PersistenceController {
    enum DataState { case loaded, notLoaded, loading, failed }
    
    lazy private var encoder = JSONEncoder()
    lazy private var decoder = JSONDecoder()
        
    private(set) var dataState: DataState = .notLoaded

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
    
    internal func loadData(completion: @escaping () -> Void) {
        print("started loading data")
        dataState = .loading
        DispatchQueue.global(qos: .background).async {
            self.loadData()
            DispatchQueue.main.async { completion() }
        }
    }
    
    internal func loadData() {
        if let savedItems = Data.load(fromFile: filename) {
            if let loadedItems = try? decoder.decode([ItemType].self, from: savedItems) {
                sleep(12)
                self.items = loadedItems
                dataState = .loaded
            } else { dataState = .failed }
        }
        
    }
    
    internal func saveData() {
        guard dataState == .loaded else { return }
        if let encoded = try? encoder.encode(items) {
            DispatchQueue.global(qos: .background).async {
                encoded.save(toFile: self.filename)
            }
        }
    }
    
    init(filename: String) {
        self.filename = filename
    }
}
