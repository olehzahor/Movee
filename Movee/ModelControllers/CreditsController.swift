//
//  CreditsController.swift
//  Movee
//
//  Created by jjurlits on 12/6/20.
//

import Foundation

class CreditsController {
    private var credits: Credits
    
    private var combined: [Character] {
        return (credits.cast ?? []) + (credits.crew ?? [])
    }
    
    private var popular: [Character] {
        return combined.filter({$0.popularity > 1})
    }
    
    private var groupedByDepartment: [Dictionary<String?, [Character]>.Element] {
        let sortedCast = credits.cast?.sorted(by: {$0.order ?? -1 < $1.order ?? -1}) ?? []
        let crew = credits.crew ?? []
        let groupedCredits = Dictionary(grouping: sortedCast + crew, by: {$0.known_for_department})
        let alphabeticalySortedGroupedCredits = groupedCredits.sorted(by: {$0.key ?? "" < $1.key ?? "" })
        return alphabeticalySortedGroupedCredits
    }
       
    var short: [Character] {
        let crew = credits.crew ?? []
        let directors = crew.filter { $0.job == "Director" }
        let popular = self.popular.filter { !directors.contains($0) }
        return directors + popular
    }
    
    var long: [Dictionary<String?, [Character]>.Element] {
        return groupedByDepartment
    }
    
//    lazy var sections: [Section] = {
//        return credits.groupedByDepartment
//            .compactMap { Section(title: $0, items: $1) }
//    }()
//
//    static func viewModels(for list: [Character]) -> [CharacterViewModel] {
//        return list.compactMap { CharacterViewModel(character: $0) }
//    }
    
    init(credits: Credits) {
        self.credits = credits
    }
        
    //TODO: create more initializers
//    init(movieId: Int) {
//
//    }
}

extension Credits {
    var controller: CreditsController {
        return CreditsController(credits: self)
    }
}
