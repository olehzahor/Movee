//
//  Person.swift
//  Movee
//
//  Created by jjurlits on 11/30/20.
//

import Foundation

struct Person: MediaListItem {
    static var placeholder: Person { return .init() }
    
    var birthday: String?
    var known_for_department: String?
    var deathday: String?
    var id: Int?
    var name: String?
    //var also_known_as: String?
    var gender: Int?
    var biography: String?
    var popularity: Double?
    var place_of_birth: String?
    var profile_path: String?
    var adult: Bool?
    var imdb_id: String?
    var homepage: String?
    var movie_credits: MovieCredits?
    var also_known_as: [String]?
}


extension Person {
    var genderString: String {
        switch gender {
        case 1:
            return "Female".l10ed
        case 2:
            return "Male".l10ed
        default:
            return "Unknown".l10ed
        }
    }
    
    var age: Int {
        guard let birthdayDate = birthdayDate else { return 0 }
        let calendar = Calendar.current
        let deathdayDate = self.deathdayDate ?? Date()
        let ageComponents = calendar.dateComponents([.year], from: birthdayDate, to: deathdayDate)
        return ageComponents.year!
    }
    
    var birthdayDate: Date? {
        guard let birthday = birthday else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: birthday)
    }
    
    var deathdayDate: Date? {
        guard let deathday = deathday else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: deathday)
    }


}

struct MovieCredits: Codable, Hashable {
    var cast: [Movie]?
    var crew: [Movie]?
    var combined: [Movie] {
        return (cast ?? []) + (crew ?? [])
    }
    
    private func filterAndSortByYear(_ list: [Movie]?) -> [Movie] {
        let filteredList = list?.filter {
            !($0.release_date ?? "").isEmpty
        } ?? []
        let sortedList = filteredList.sorted(by: { $0.release_date! > $1.release_date! })
        return sortedList
    }
    
    var groupedByDepartment: [String: [Movie]] {
        let cast = filterAndSortByYear(self.cast)
        let crew = filterAndSortByYear(self.crew)
        var grouped = Dictionary(grouping: crew, by: { $0.department ?? "Other" })
        grouped["Acting"] = cast
        return grouped
    }

}
