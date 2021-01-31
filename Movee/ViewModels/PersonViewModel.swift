//
//  PersonViewModel.swift
//  Movee
//
//  Created by jjurlits on 11/30/20.
//

import UIKit
import SDWebImage

class PersonViewModel {
    var person: Person?
    var preloadedPhoto: UIImage?
    
    var name: String {
        return person?.name ?? ""
    }
    
    var imageURL: URL? {
        guard let profilePath = person?.profile_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185/\(profilePath)")
    }

    var hiresImageURL: URL? {
        guard let profilePath = person?.profile_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w780/\(profilePath)")
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
    
    var biography: String? {
        return person?.biography
    }
    
    var knownForDepartment: String {
        return person?.known_for_department ?? ""
    }
    
    func createStringFromDate(_ date: Date, appendAge: Bool) -> String {
        var formattedDate = formatDate(date)
        if appendAge, let age = person?.age {
            formattedDate += " (\(age))"
        }
        return formattedDate
    }
    
    var birthdayString: String {
        guard let birthday = person?.birthdayDate else { return "" }
        return createStringFromDate(birthday, appendAge: person?.deathday == nil)
    }
    
    var deathdayString: String {
        guard let deathday = person?.deathdayDate else { return "" }
        return createStringFromDate(deathday, appendAge: true)
    }
    
    var placeOfBirth: String {
        return person?.place_of_birth ?? ""
    }
    
    var gender: String {
        return person?.genderString ?? ""
    }

    
    init(person: Person) {
        self.person = person
        print("person view model for \(person.name ?? "") created")
    }
}

extension PersonViewModel {
    func configure(_ view: PersonPhotoCell, imageLoaded: (() -> Void)? = nil) {
        if imageURL != nil {
            let cachedLowres = SDImageCache.shared.imageFromCache(forKey: imageURL?.absoluteString)
            view.setPhoto(photoUrl: hiresImageURL, placeholder: cachedLowres)
        }
    }
    
    func configure(_ view: BiographyCell) {
        view.biographyLabel.text = person?.biography
    }
}

extension Person {
    var viewModel: PersonViewModel {
        return PersonViewModel(person: self)
    }
}
