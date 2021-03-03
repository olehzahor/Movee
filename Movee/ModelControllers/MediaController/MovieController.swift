//
//  MovieController2.swift
//  Movee
//
//  Created by jjurlits on 2/25/21.
//

import Foundation



class MovieController: MediaController<Movie> {
    override var viewModel: MediaViewModel? {
        return media.viewModel
    }
    
    override var related: [Movie]? {
        return media.recommendations?.results
    }
    
    override func loadDetails(completion: @escaping (MediaController<Movie>) -> Void) {
        guard let movieId = media.id else { return }
        
        let _ = TMDBClient.shared.getMovieDetails(id: movieId) { result in
            switch result {
            case .success(let movie):
                self.media = movie
                self.isDetailsLoaded = true
            case .failure(let error):
                self.error = error
            }
            completion(self)
        }
    }
}


//
//class MovieController2: MediaController {
//    var seasons: [Season]?
//    
//    func loadDetails(completion: @escaping (MediaController) -> Void) {
//        fetchDetails(completion: completion)
//    }
//    
//    var viewModel: MediaViewModel?
//    
//    var isDetailsLoaded: Bool = false
//    
//    var related: [Movie]? {
//        return movie?.recommendations?.results
//    }
//    
//    var mediaId: Int?
//    var mediaType: MediaType? = .movie
//    var movie: Movie? {
//        didSet { viewModel = movie?.viewModel }
//    }
//    var credits: Credits? { return movie?.credits }
//    
//    var trailer: VideoResult?
//    
//    var isPosterAvaiable: Bool { return movie?.poster_path != nil }
//    var isBackdropAvaiable: Bool { return movie?.backdrop_path != nil }
//    
//    var error: Error?
//
//    private func fetchDetails(completion: @escaping (MediaController) -> Void) {
//        guard let movieId = mediaId else { return }
//        
//        let _ = TMDBClient.shared.getMovieDetails(id: movieId) { result in
//            switch result {
//            case .success(let movie):
//                self.movie = movie
//                self.isDetailsLoaded = true
//            case .failure(let error):
//                self.error = error
//            }
//            completion(self)
//        }
//    }
//    
//    convenience init(movieId: Int) {
//        self.init()
//        self.mediaId = movieId
//    }
//    
//    convenience init(movie: Movie) {
//        self.init()
//        self.movie = movie
//        self.mediaId = movie.id
//        self.viewModel = movie.viewModel
//    }
//
//}
