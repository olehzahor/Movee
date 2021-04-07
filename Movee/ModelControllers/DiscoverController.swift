//
//  ExploreController.swift
//  Movee
//
//  Created by jjurlits on 12/11/20.
//

import Foundation
import FirebaseDatabase

extension DataSnapshot {
    var json: Data? {
        guard let value = value else { return nil }
        return try? JSONSerialization.data(withJSONObject: value, options: .withoutEscapingSlashes)
    }
}

class RemoteDiscoverController: DiscoverController {
    private(set) var database: DatabaseReference
    private(set) var databasePath: String
    
    init(database: DatabaseReference, path: String) {
        self.database = database
        self.databasePath = path
        super.init()
    }
    
    @objc override func loadData(completion: (() -> Void)? = nil) {
        let ref = database.child(databasePath)
        ref.observeSingleEvent(
            of: .value, with: { (snapshot) in
                guard let jsonData = snapshot.json else { return }
                DispatchQueue.global(qos: .utility).async {
                    if let lists = try? JSONDecoder().decode([DiscoverListItem].self, from: jsonData) {
                        self.lists = lists
                        DispatchQueue.main.async { completion?() }
                    }
                }
            })
    }
}

class DiscoverController {
    private(set) var filename: String?
    
    internal var lists = [DiscoverListItem]()
    private(set) var isNested = false
    private(set) var name: String?
    
    func moved(to list: DiscoverListItem) -> DiscoverController? {
        return DiscoverController(lists: list.nestedLists ?? [], isNested: true, name: list.localizedName)
    }
    
    init(lists: [DiscoverListItem], isNested: Bool = false, name: String? = nil) {
        self.lists = lists
        self.isNested = isNested
        self.name = name
    }
    
    init(fromBundle filename: String) {
        self.filename = filename
    }
    
    init() { }
}

extension DiscoverController {
    @objc func loadData(completion: (() -> Void)? = nil) {
        guard let filename = filename else {
            completion?()
            return
        }
        
        DispatchQueue.global(qos: .utility).async {
            self.lists = Bundle.main.decode(from: filename)
            DispatchQueue.main.async { completion?() }
        }
    }
}
