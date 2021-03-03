//
//  SeasonViewModel.swift
//  Movee
//
//  Created by jjurlits on 2/20/21.
//

import UIKit

class SeasonViewModel {
    private var season: Season
        
    var posterURL: URL? {
        guard let posterPath = season.poster_path else { return nil }
        return TMDBClient.shared.fullPosterUrl(path: posterPath)
    }
    
    var posterPlaceholder: UIImage? {
        return UIImage(named: "placeholder")
    }
    
    var placeholderText: String {
        seasonNumber > 0 ? "\(seasonNumber)" : "S"
    }
    
    var title: String {
        guard let seasonName = season.name else { return "" }
        return "\(seasonName) (\(year))"
    }
    
    private func createAttributedString(_ string: String, font: UIFont) -> NSMutableAttributedString {
        let attributes = [NSAttributedString.Key.font : font]
        return NSMutableAttributedString(string: string, attributes: attributes)
    }
    
    var attributedTitle: NSAttributedString {
        guard let seasonName = season.name else { return NSAttributedString() }
        let attributedString = createAttributedString(seasonName, font: .systemFont(ofSize: 12, weight: .bold))
        if !year.isEmpty {
            attributedString.append(
                createAttributedString(" \(year)", font: .systemFont(ofSize: 12, weight: .regular)))
        }

        return attributedString
    }
    
    var subtitle: String {
        guard let episodes = season.episode_count else { return "" }
        return "\(episodes) Episodes"
    }
    
    var year: String {
        guard let airDate = season.air_date else { return "" }
        return TMDBDateFormatter.shared.year(fromDateString: airDate)
    }
    
    var seasonNumber: Int {
        return season.season_number ?? 0
    }
    
    init(_ season: Season) {
        self.season = season
    }
}

extension SeasonViewModel {
    func configure(_ view: CompactMovieCell) {
        view.titleLabel.attributedText = attributedTitle
        view.subtitleLabel.text = subtitle
        view.poster.imageView.sd_setImage(with: posterURL,
                                          placeholderImage: posterPlaceholder)
    }
}

extension Season {
    var viewModel: SeasonViewModel {
        return SeasonViewModel(self)
    }
}
