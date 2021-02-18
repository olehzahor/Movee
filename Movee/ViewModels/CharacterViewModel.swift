//
//  CastViewModel.swift
//  Movee
//
//  Created by jjurlits on 11/12/20.
//

import UIKit

class CharacterViewModel: Hashable {
    static func == (lhs: CharacterViewModel, rhs: CharacterViewModel) -> Bool {
        lhs.character == rhs.character
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(character)
    }
    
    internal let character: Character
    
    var imageURL: URL? {
        guard let profilePath = character.profile_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185/\(profilePath)")
    }
    
    var placeholder: UIImage? {
        return UIImage(named: character.gender == 1 ? "placeholder-female" : "placeholder-male")
    }
    
    var name: String {
        return character.name ?? ""
    }
    
    var originalName: String? {
        if character.name != character.original_name {
            return character.original_name
        } else {
            return nil
        }
    }
    
    var subtitle: String {
        return character.character ?? character.job ?? ""
    }
    
    var knownFor: String {
        let movies = character.known_for?.compactMap { $0.title }
        return movies?.joined(separator: "\n") ?? ""
    }
    
    
    init(character: Character) {
        self.character = character
    }
}

extension CharacterViewModel {
    func configure(_ view: CharacterCell) {
        view.imageView.sd_setImage(with: imageURL, placeholderImage: placeholder)
        view.label.text = name
        view.subLabel.text = subtitle
    }

    func configure(_ view: CharacterHorizontalCell) {
        view.imageView.sd_setImage(with: imageURL, placeholderImage: placeholder)
        view.titleLabel.text = name
        view.originalTitleLabel.text = originalName
        view.subtitleLabel.text = subtitle
    }
    
    func configure(_ view: CharacterSearchCell) {
        view.titleLabel.text = name
        view.subtitleLabel.text = knownFor
        view.imageView.sd_setImage(with: imageURL, placeholderImage: placeholder)
    }
}

