////
////  MovieSearchResultsViewModel.swift
////  Movee
////
////  Created by jjurlits on 11/23/20.
////
//
//import Foundation
//
//class MovieSearchResultsViewModel: MoviesListViewModel {
//    var query: String
//
//    override func fetch(page: Int, completion: (() -> ())? = nil) {
//        guard !query.isEmpty else {
//            genericCompletionHandler(
//                result: .failure(ApiService.NetworkError.badRequest),
//                completion: completion)
//            return
//        }
//        
//        print("start fetching...")
//        
//        task = TMDBClient.shared.searchMovies(query: query, page: page) { (result) in
//            self.genericCompletionHandler(result: result, completion: completion)
//        }
//    }
//    
//    init(query: String, locale: String = "en_US", initialPage: Int = 1) {
//        self.query = query
//        super.init(locale: locale, initialPage: initialPage)
//    }
//}
