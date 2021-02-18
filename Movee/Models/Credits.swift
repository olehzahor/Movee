//
//  Credits.swift
//  Movee
//
//  Created by jjurlits on 11/29/20.
//

import Foundation

struct Credits: Codable, Hashable {
    var cast: [Character]?
    var crew: [Character]?
    
    var all: [Character] {
        return (cast ?? []) + (crew ?? [])
    }
    
    var popular: [Character] {
        return all.filter({$0.popularity > 1})
    }
    
    var groupedByDepartment: [Dictionary<String, [Character]>.Element] {
        let sortedCast = cast?.sorted(by: {$0.order ?? -1 < $1.order ?? -1}) ?? []
        let crew = self.crew ?? []
        let groupedCredits = Dictionary(grouping: sortedCast + crew, by: {$0.known_for_department})
        
        let alphabeticalySortedGroupedCredits = groupedCredits.sorted(by: {$0.key < $1.key })
        return alphabeticalySortedGroupedCredits
    }
}

//TODO: check for 'order' thing
struct Character: Codable, Hashable {
    var cast_id: Int?
    var credit_id: String?
    var gender: Int?
    var id: Int?
    var name: String?
    var order: Int?
    var profile_path: String?
    var character: String?
    var job: String?
    var popularity: Double = 0
    var known_for_department: String = ""
    var original_name: String?
    
    var known_for: [Movie]?
    
    static var placeholder = Character()
}

extension Character {
    var viewModel: CharacterViewModel {
        return CharacterViewModel(character: self)
    }
}

struct PeoplePagedResult: Codable, Hashable {
    var page: Int
    var results: [Character]
    var total_pages: Int
    var total_results: Int
}

