//
//  AsynchronousJSON.swift
//  Movee
//
//  Created by jjurlits on 3/15/21.
//

import Foundation

class AsynchronousJSONPersistenceController<T: Codable&Hashable>: PersistenceController {
    func loadData() {
        loadData(completion: nil)
    }
    
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
    
    internal func loadData(completion: (() -> Void)? = nil) {
        print("started loading data")
        dataState = .loading
        DispatchQueue.global(qos: .background).async {
            sleep(10)
            self._loadData()
            DispatchQueue.main.async { completion?() }
        }
    }
    
    private func _loadData() {
        if let savedItems = Data.load(fromFile: filename) {
            if let loadedItems = try? decoder.decode([ItemType].self, from: savedItems) {
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
