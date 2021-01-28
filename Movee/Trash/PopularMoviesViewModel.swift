////
////  PopularMoviesViewModel.swift
////  Movee
////
////  Created by jjurlits on 11/12/20.
////
//
//import Foundation
//
//class RelatedMoviesViewModel: MoviesListViewModel {
//    var movieId: Int
//    
//    override func fetch(page: Int, completion: (() -> ())? = nil) {
//        print("fetching page \(page)")
//        TMDBClient.shared.getRelatedMovies(movieId: movieId, page: page) { result in
//            print("page \(page) fetched")
//            self.genericCompletionHandler(result: result, completion: completion)
//        }
//    }
//    
//    init(movieId: Int, locale: String = "en_US", initialPage: Int = 1) {
//        self.movieId = movieId
//        super.init(locale: locale, initialPage: initialPage)
//    }
//}
//
//class PopularMoviesViewModel: MoviesListViewModel {
//    override func fetch(page: Int, completion: (() -> ())? = nil) {
//        print("fetching page \(page)")
//        TMDBClient.shared.getPopularMovies(page: page) { result in
//            print("page \(page) fetched")
//            self.genericCompletionHandler(result: result, completion: completion)
//        }
//    }
//}
