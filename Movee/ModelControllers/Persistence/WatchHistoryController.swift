//
//  WatchHistoryController.swift
//  Movee
//
//  Created by jjurlits on 1/25/21.
//

import Foundation

class WatchHistoryController: SearchHistoryController {
    override var title: String { return "Watch History" }
    
    func removeMovie(_ movie: Movie) {
        items.removeAll { $0.id == movie.id }
        saveData()
    }
    
    func contains(_ movie: Movie) -> Bool {
        return items.contains { $0.id == movie.id }
    }
    
    convenience init() {
        self.init(filename: "watch_history.json")
    }
    
}

