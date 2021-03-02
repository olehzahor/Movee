//
//  MovieViewModel.swift
//  Movee
//
//  Created by jjurlits on 11/10/20.
//

import UIKit

class MovieViewModel: AnyMediaViewModel<Movie> {
    override var subtitle: String {
        if let character = media.character {
            return character
        } else if let job = media.job {
            return job
        } else {
            return ""
        }
    }
        
    override var runtime: String {
        guard let runtime = media.runtime, runtime > 0 else { return "" }
        
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief
        return formatter.string(from: TimeInterval(runtime * 60)) ?? ""
    }
    
        
    override var infoString: InfoString {
        let short = separate([year, genresString.short], separator: separator)
        
        var long = separate([releaseDate, runtime], separator: separator)
        if !long.isEmpty, !genresString.long.isEmpty { long += "\n" }
        long += genresString.long
        
        return InfoString(short: short, long: long)
    }
    
    override var originalTitle: String {
        if media.original_title != media.title {
            return media.original_title ?? ""
        } else { return "" }
    }
    
    
    override var year: String {
        guard let releaseDateString = media.release_date else { return "" }
        return TMDBDateFormatter.shared.year(fromDateString: releaseDateString)
    }
    
    override var facts: [[String: String]] {
        var rows = super.facts
        
        let releaseDateFullString = TMDBDateFormatter.shared.localizedDateString(fromDateString: media.release_date, style: .full)
        
        if !releaseDateFullString.isEmpty {
            rows = [["Release Date": releaseDateFullString]] + rows
        }
        
        var savedBudget: Double?
        if let budget = media.budget, budget > 0 {
            rows.append(["Budget": NSNumber(value: budget).dollars])
            savedBudget = budget
        }

        if let revenue = media.revenue, revenue > 0 {
            let revenueStr = NSNumber(value: revenue).dollars
            var prefix = ""
            if let budget = savedBudget {
                prefix = revenue > budget ? "↑ " : "↓ "
            }
            rows.append(["Revenue": "\(prefix)\(revenueStr)"])
        }

        return rows
    }

    
    init(movie: Movie) {
        super.init(media: movie)
    }
}

