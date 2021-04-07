//
//  AsynchronousJSON.swift
//  Movee
//
//  Created by jjurlits on 3/15/21.
//

import Foundation

class AsynchronousJSONPersistenceController<T: Codable&Hashable>: PersistenceController {
    internal var taskQueue = DispatchQueue.global(qos: .userInteractive)
    
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
    
    private var isFileExists: Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(filename) {
            let filePath = pathComponent.path
            let fileManager = FileManager.default
            return fileManager.fileExists(atPath: filePath)
        } else {
            return false
        }
    }
    
    internal func loadData(completion: (() -> Void)? = nil) {
        print("started loading data")
        dataState = .loading
        taskQueue.async {
            self._loadData()
            DispatchQueue.main.async { completion?() }
        }
        
//        DispatchQueue.global(qos: .utility).async {
//            self._loadData()
//            DispatchQueue.main.async { completion?() }
//        }
    }
    
    private func _loadData() {
        guard isFileExists else { dataState = .loaded; return }
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
            taskQueue.async {
                encoded.save(toFile: self.filename)
            }
        }
    }
    
    internal init(filename: String) {
        self.filename = filename
    }
}
