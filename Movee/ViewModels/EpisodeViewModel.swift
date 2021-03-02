//
//  EpisodeViewModel.swift
//  Movee
//
//  Created by jjurlits on 2/24/21.
//


import Foundation

class EpisodeViewModel {
    private var episode: Episode
    
    var title: String {
        return "\(episode.episode_number!). \(episode.name!)"
    }
    
    var subtitle: String {
        guard let airDate = episode.air_date else { return "" }
        return TMDBDateFormatter.shared.localizedDateString(fromDateString: airDate,
                                                            style: .full)
    }
    
    var stillUrl: URL? {
        guard let stillPath = episode.still_path else { return nil }
        return TMDBClient.shared.fullBackdropUrl(path: stillPath)
    }
    
    init(_ episode: Episode) {
        self.episode = episode
    }
}

extension EpisodeViewModel {
    func configure(_ view: EpisodeCell, isExpanded: Bool! = false) {
        view.titleLabel.text = title
        view.subtitleLabel.text = subtitle
        view.overviewLabel.text = episode.overview
                    
        view.overviewLabel.numberOfLines = isExpanded ? 0 : 3
        view.titleLabel.numberOfLines = isExpanded ? 0 : 1
        view.subtitleLabel.numberOfLines = isExpanded ? 0 : 1
        
        if let stillUrl = stillUrl {
            view.stillImageView.isHidden = false
            view.stillImageView.sd_setImage(with: stillUrl)
        } else { view.stillImageView.isHidden = true }
        
        if let episodeRating = episode.vote_average {
            view.ratingView.setRating(episodeRating)
        }
    }
}

extension Episode {
    var viewModel: EpisodeViewModel { return EpisodeViewModel(self) }
}
