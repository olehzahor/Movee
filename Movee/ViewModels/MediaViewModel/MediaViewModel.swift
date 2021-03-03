//
//  MediaViewModel.swift
//  Movee
//
//  Created by jjurlits on 2/19/21.
//

import UIKit

struct InfoString {
    let short: String
    let long: String
}

protocol MediaViewModel {
    var id: Int? { get }

    var title: String { get }
    var titleWithYear: String? { get }
    var attributedTitleWithYear: NSAttributedString { get }
    var originalTitle: String { get }
    var subtitle: String { get }
    var tagline: String { get }
    var rating: Double { get }
    var runtime: String { get }
    var year: String { get }
    var releaseDate: String { get }
    var genresString: InfoString { get }
    var infoString: InfoString { get }
    var overview: String? { get }
    var genres: [String] { get }
    
    var posterURL: URL? { get }
    var backdropURL: URL? { get }
    var posterPlaceholder: UIImage? { get }
    var backdropPlaceholder: UIImage? { get }
    
    var titleAndCharacter: NSAttributedString { get }
    
    var facts: [[String: String]] { get }
}

extension MediaViewModel {
    var titleAndCharacter: NSAttributedString {
        return createAttributedTitleSubtitleString(separator: " as ")
    }

    //var genres: Genres?
//    {
//        return TMDBClient.shared.genres
//    }

    var attributedTitleWithYear: NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: title)
        let attrs = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let attributedYear = NSMutableAttributedString(string: " \(year)", attributes:attrs)
        attributedTitle.append(attributedYear)
        return attributedTitle
    }
    
    var posterPlaceholder: UIImage? {
        return UIImage(named: "placeholder")
    }
    
    var backdropPlaceholder: UIImage? {
        return UIImage(named: "backdrop-placeholder")
    }
    
    var titleWithYear: String? {
        return "\(title) (\(year))"
    }
    
    internal func separate(_ strings: [String], separator: String) -> String {
        return strings.filter({!$0.isEmpty}).joined(separator: separator)
    }

    
    internal func createAttributedTitleSubtitleString(separator: String) -> NSMutableAttributedString {
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
    
//    internal func dateFromDateString(_ dateString: String?) -> Date? {
//        guard let dateString = dateString else {
//            return nil
//        }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-mm-dd"
//        return formatter.date(from: dateString)
//    }
//
//    internal func getYearFromDate(_ releaseDateString: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        if let date = dateFormatter.date(from: releaseDateString) {
//            let calendar = Calendar.current
//            return "\(calendar.component(.year, from: date))"
//        } else {
//            return ""
//        }
//    }
}

extension MediaViewModel {
    func configure(_ view: DescriptionCell) {
        if backdropURL == nil {
            view.setupWithoutOverlap()
        }
        
        view.titleLabel.text = title
        view.originalTitleLabel.text = originalTitle
        view.infoLabel.text = infoString.long
        view.taglineLabel.text = tagline
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
        view.infoLabel.attributedText = titleAndCharacter
    }
    
    func configure(_ view: MovieCell) {
        view.titleLabel.text = title
        view.infoLabel.text = infoString.short
        let overviewText = overview
        view.overviewLabel.text = overviewText
        view.poster.imageView.sd_setImage(with: posterURL, placeholderImage: posterPlaceholder)
        view.poster.setRating(rating)
    }
    
    func configure(_ view: BackdropView) {
        view.imageView.sd_setImage(with: backdropURL)
    }
}
