//
//  MovieViewModel.swift
//  Movee
//
//  Created by jjurlits on 11/10/20.
//

import UIKit

//struct Container {
//    let id: Any
//    let type: AnyHashable.Type
//}

protocol ViewModelDelegate: class {
    func didFinishLoading()
}

class MovieViewModel {
    private(set) var movie: Movie
    private let separator = " ・ "
    
    var genres: Genres? {
        return TMDBClient.shared.genres
    }
    
    var subtitle: String {
        if let character = movie.character {
            return character
        } else if let job = movie.job {
            return job
        } else {
            return ""
        }
    }
    
    var rating: Double {
        return movie.vote_average ?? 0.0
    }
    
    var runtime: String {
        guard let runtime = movie.runtime, runtime > 0 else { return "" }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief
        return formatter.string(from: TimeInterval(runtime * 60)) ?? ""
    }
    
    var id: Int? {
        return movie.id
    }

    var posterURL: URL? {
        guard let posterPath = movie.poster_path else { return nil }
        return TMDBClient.shared.fullPosterUrl(path: posterPath)
    }
    
    var backdropURL: URL? {
        guard let backdropPath = movie.backdrop_path else { return nil }
        return TMDBClient.shared.fullBackdropUrl(path: backdropPath)
    }
    
    var posterPlaceholder: UIImage? {
        return UIImage(named: "placeholder")
    }
    
    var backdropPlaceholder: UIImage? {
        return UIImage(named: "backdrop-placeholder")
    }
    
    var title: String {
        return movie.title ?? ""
    }
    
    var titleWithYear: String? {
        return "\(title) (\(year))"
    }
    
    var attributedTitleWithYear: NSAttributedString? {
        let attributedTitle = NSMutableAttributedString(string: title)
        let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let attributedYear = NSMutableAttributedString(string: " \(year)", attributes:attrs)
        attributedTitle.append(attributedYear)
        return attributedTitle
    }
    
    struct InfoString {
        let short: String
        let long: String
    }
    
    var genresString: InfoString {
        var short = ""
        var long = ""
        
        if let genres = movie.genres {
            short = genres.first?.name ?? ""
            long = genres.compactMap({$0.name}).joined(separator: separator)
        } else if let genreIds = movie.genre_ids {
            short = genres?.name(for: genreIds.first ?? 0) ?? ""
            long = genres?.string(from: genreIds) ?? ""
        }
        return InfoString(short: short, long: long)
    }
    
    var releaseDate: String {
        guard let date = Movie.dateFromDateString(movie.release_date) else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    var infoString: InfoString {
        var short = [year, genresString.short].joined(separator: separator)
        var long = ""
        if runtime.isEmpty {
            long = [releaseDate, genresString.long].joined(separator: separator)
        } else {
            long = [releaseDate, runtime].joined(separator: separator)
            long += "\n" + genresString.long
        }
        
        return InfoString(short: short, long: long)
    }
    
    var originalTitle: String {
        if movie.original_title != movie.title {
            return movie.original_title ?? ""
        } else { return "" }
    }
    
    fileprivate func createAttributedTitleSubtitleString(separator: String) -> NSMutableAttributedString {
        let boldAttrs: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        
        let greyAttrs: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ]
        let normalAttrs: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.label
        ]
        
        let aStr = NSMutableAttributedString()
        aStr.append(NSAttributedString(string: title, attributes: boldAttrs))
        if !subtitle.isEmpty {
            aStr.append(NSAttributedString(string: separator, attributes: greyAttrs))
            aStr.append(NSAttributedString(string: subtitle, attributes: normalAttrs))
        }
        return aStr
    }

    var overview: String? {
        return movie.overview
    }
    
    var year: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let releaseDateString = movie.release_date, let date = dateFormatter.date(from: releaseDateString) {
            let calendar = Calendar.current
            return "\(calendar.component(.year, from: date))"
        } else {
            return ""
        }
    }
    
    init(movie: Movie) {
        self.movie = movie
    }
}

extension MovieViewModel {
    func configure(_ view: DescriptionCell) {
        if backdropURL == nil {
            view.setupWithoutOverlap()
        }
        
        view.titleLabel.text = title
        view.originalTitleLabel.text = originalTitle
        view.infoLabel.text = infoString.long
        view.overviewLabel.text = overview
        view.poster.imageView.sd_setImage(with: posterURL,
                                         placeholderImage: posterPlaceholder)
    }
    
    func configure(_ view: CompactMovieCell) {
        view.titleLabel.text = title
        view.poster.imageView.sd_setImage(with: posterURL, placeholderImage: posterPlaceholder)
        view.subtitleLabel.text = subtitle
        view.poster.setRating(rating)
    }
    
    func configure(_ view: MovieListCell) {
        view.yearLabel.text = year
        view.infoLabel.attributedText = createAttributedTitleSubtitleString(separator: " as ")
    }
    
    func configure(_ view: MovieCell) {
        view.titleLabel.text = title
        view.infoLabel.text = infoString.short
        view.overviewLabel.text = overview
        view.poster.imageView.sd_setImage(with: posterURL, placeholderImage: posterPlaceholder)
        view.poster.setRating(rating)
    }
    
    func configure(_ view: BackdropView) {
        view.imageView.sd_setImage(with: backdropURL)
    }
}

extension Movie {
    var viewModel: MovieViewModel {
        return MovieViewModel(movie: self)
    }
}
