//
//  CastAndCrewViewModel.swift
//  Movee
//
//  Created by jjurlits on 11/12/20.
//

import Foundation


//transform to model
struct CreditsViewModel: Hashable {
    struct Section {
        var title: String
        var items: [Character]
    }
    
    var credits: Credits
    
    var short: [Character] {
        let directors = credits.all.filter { $0.job == "Director" }
        let popular = credits.popular.filter { !directors.contains($0) }
        return directors + popular
    }
    
    var long: [Dictionary<String, [Character]>.Element] {
        return credits.groupedByDepartment
    }
    
    lazy var sections: [Section] = {
        return credits.groupedByDepartment
            .compactMap { Section(title: $0, items: $1) }
    }()
    
    static func viewModels(for list: [Character]) -> [CharacterViewModel] {
        return list.compactMap { CharacterViewModel(character: $0) }
    }
    
    init(credits: Credits) {
        self.credits = credits
    }
}













//
//    private let cast: [Character]?
//    private let crew: [Character]?
//    private lazy var castAndCrew: [Character] = {
//        return (cast ?? []) + (crew ?? [])
//    }()
//
//    private var shortCastAndCrew: [Character] {
//        return castAndCrew.filter({$0.popularity > 1})
//    }
    
//    var count: Int {
//        return castAndCrew.count
//    }
    
//    var characterViewModels: [CharacterViewModel] {
//        return shortCastAndCrew.compactMap { CharacterViewModel(character: $0) }
//    }
//
//    var fullCreditsViewModels: [CharacterViewModel] {
//        return castAndCrew.compactMap { CharacterViewModel(character: $0)}
//    }
    
//    var groupedCredits: [String: [Character]] {
//
//    }
//
//
//
//    func some() {
//    }
//
//    //TODO: short and long list
//
//    func characterViewModel(at index: Int) -> CharacterViewModel? {
//        guard castAndCrew.indices.contains(index) else {
//            return nil
//        }
//        return CharacterViewModel(character: castAndCrew[index])
//    }
//
