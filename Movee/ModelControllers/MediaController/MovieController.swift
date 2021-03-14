//
//  MovieController2.swift
//  Movee
//
//  Created by jjurlits on 2/25/21.
//

import Foundation

//extension MediaController where T.Type == Movie.Type {
//    var viewModel: MediaViewModel? {
//        return media.viewModel
//    }
//
//    var related: [Movie]? {
//        return media.recommendations?.results
//    }
//
//    func loadDetails(completion: @escaping (MediaController<Movie>) -> Void) {
//        guard let movieId = media.id else { return }
//
//        let _ = TMDBClient.shared.getMovieDetails(id: movieId) { result in
//            switch result {
//            case .success(let movie):
//                self.media = movie
//                self.isDetailsLoaded = true
//            case .failure(let error):
//                self.error = error
//            }
//            completion(self)
//        }
//    }
//}



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
