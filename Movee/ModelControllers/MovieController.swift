//
//  MovieController.swift
//  Movee
//
//  Created by jjurlits on 12/6/20.
//

import Foundation

class MovieController {
    typealias UpdateHandler = (MovieController) -> ()
    typealias ErrorHandler = (Error) -> ()

    var errorHandler: ErrorHandler?
    var updateHandler: UpdateHandler?
    
    private(set) var isDetailsFetched = false

    private(set) var movie: Movie? {
        didSet {
            viewModel = MovieViewModel(movie: movie!)
        }
    }
    private(set) var viewModel: MovieViewModel?
    private var movieId: Int?
    
    var generalInfo: [[String: String]] {
        guard isDetailsFetched else { return [] }
        
        var rows = [[String: String]]()
        if let releaseDate = Movie.dateFromDateString(movie?.release_date) {
            let formatter = DateFormatter()
            formatter.dateStyle = .full
            rows.append(["Release Date": formatter.string(from: releaseDate)])
        }
        
        if let countries = movie?.production_countries, !countries.isEmpty {
            let countryStrings = countries.compactMap { $0.name }
            rows.append(["Country": countryStrings.joined(separator: "\n")])
        }
        
        if let language = movie?.original_language, !language.isEmpty {
            if let localizedString = Locale.current.localizedString(forLanguageCode: language) {
                rows.append(["Language": localizedString])
            }
        }
        
        if let rating = movie?.vote_average, let votesCount = movie?.vote_count, rating > 0, votesCount > 0 {
            rows.append(["Rating": "\(rating) (\(votesCount) votes)"])
        }
        
        var savedBudget: Double?
        if let budget = movie?.budget, budget > 0 {
            rows.append(["Budget": NSNumber(value: budget).dollars])
            savedBudget = budget
        }

        if let revenue = movie?.revenue, revenue > 0 {
            let revenueStr = NSNumber(value: revenue).dollars
            var prefix = ""
            if let budget = savedBudget {
                prefix = revenue > budget ? "↑ " : "↓ "
            }
            rows.append(["Revenue": "\(prefix)\(revenueStr)"])
        }


        return rows
    }
    
    var related: [Movie]? {
        return movie?.recommendations?.results
    }
    
    var credits: Credits? {
        return movie?.credits
    }
    
    var trailer: VideoResult? {
        guard let videos = movie?.videos?.results,
              !videos.isEmpty,
              let video = videos.first(
                where: { $0.site == "YouTube" && $0.type == "Trailer" })
        else { return nil }
        
        return video
    }
    
    var creditsController: CreditsController? {
        return credits?.controller
    }
    
    var isPosterAvaiable: Bool {
        return movie?.poster_path != nil
    }
    
    var isBackdropAvaiable: Bool {
        return movie?.backdrop_path != nil
    }
    
    private func fetchDetails() {
        guard let movieId = movieId else { return }
        
        let _ = TMDBClient.shared.getMovieDetails(id: movieId) { result in
            switch result {
            case .success(let movie):
                self.movie = movie
                self.isDetailsFetched = true
                self.updateHandler?(self)
            case .failure(let error):
                self.errorHandler?(error)
            }
        }
    }
    
    func show() {
        updateHandler?(self)
    }
    
    func load() {
        fetchDetails()
    }
    
    init(movie: Movie, updateHandler: UpdateHandler? = nil) {
        self.movie = movie
        self.viewModel = MovieViewModel(movie: movie)
        self.movieId = movie.id
        self.updateHandler = updateHandler
    }
    
    init(movieId: Int, updateHandler: UpdateHandler? = nil) {
        self.movieId = movieId
    }
}
