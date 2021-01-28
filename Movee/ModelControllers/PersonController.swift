//
//  PersonController.swift
//  Movee
//
//  Created by jjurlits on 12/7/20.
//

import Foundation

class PersonController {
    typealias UpdateHandler = (PersonController) -> ()
    typealias ErrorHandler = (Error) -> ()

    var errorHandler: ErrorHandler?
    var updateHandler: UpdateHandler?

    private(set) var person: Person! {
        didSet {
            viewModel = PersonViewModel(person: person)
        }
    }
    private(set) var viewModel: PersonViewModel?
    
    struct PhotoAndNameItem: Hashable {
        var name: String
        var person: Person
        var isImageLoaded: Bool
    }
    
    struct PersonalInfo: Hashable {
        let key: String
        let value: String
    }
    
    struct MovieCredits: Hashable {
        var department: String
        var items: [Movie]
    }
        
    var personalInfoDictionary: [PersonalInfo] {
        var personalInfo = [PersonalInfo]()
        guard let viewModel = viewModel else { return personalInfo }
        
        if let knownFor = person?.known_for_department {
            personalInfo.append(.init(key: "Known for", value: knownFor))
        }
        
        if person?.birthdayDate != nil {
            personalInfo.append(
                .init(key: "Birthday", value: viewModel.birthdayString))
        }
        
        if person?.deathdayDate != nil {
             personalInfo.append(
                .init(key: "Deathday", value: viewModel.deathdayString))
        }
        
        if person?.place_of_birth != nil {
            personalInfo.append(
                .init(key: "Place of birth", value: viewModel.placeOfBirth))
        }
        
        if let gender = person?.gender, gender > 0 {
            personalInfo.append(.init(key: "Gender", value: viewModel.gender))
        }
                
        return personalInfo
    }

    var knownFor: [Movie] {
        guard let movieCredits = person?.movie_credits else { return [] }
        
        var ids = [Int]()
        
        let uniqueMovies = movieCredits.combined.filter {
            guard let movieId = $0.id else { return false }
            let isDuplicated = ids.contains(movieId)
            ids.append(movieId)
            return !isDuplicated
        }

        let popular = uniqueMovies.sorted {
                $0.popularity ?? 0 > $1.popularity ?? 0
            }
            
        let limiter = popular.count //< 10 ? popular.count : 10
        
        return Array(popular[..<limiter])
    }
    
    lazy var movieCredits: [MovieCredits]? = {
        return
            person?.movie_credits?
            .groupedByDepartment
            .sorted(by: { $0.key < $1.key })
            .compactMap { MovieCredits(department: $0.key, items: $0.value) }
    }()
    
    private func fetchDetails() {
        guard let personId = person?.id else { return }
        
        TMDBClient.shared.getPersonDetails(personId: personId) { [self] result in
            switch result {
            case .success(let person):
                self.person = person
                DispatchQueue.main.async {
                    updateHandler?(self)
                }
                
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    errorHandler?(error)
                }
            }
        }
    }
    
    func load() {
        fetchDetails()
    }
    
    init(character: Character) {
        person = Person()
        person?.id = character.id
        person?.name = character.name
        person?.profile_path = character.profile_path
    }
    
    //TODO: init with id

}
