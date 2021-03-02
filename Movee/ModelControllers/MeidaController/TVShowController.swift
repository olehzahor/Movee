//
//  TVShowController2.swift
//  Movee
//
//  Created by jjurlits on 2/25/21.
//

import Foundation

class TVShowController: MediaController<TVShow> {
    override var viewModel: MediaViewModel? {
        return media.viewModel
    }
    
    override var seasons: [Season]? {
        return media.seasons
    }
    
    override var related: [TVShow]? {
        return media.recommendations?.results
    }
    
    override func loadDetails(completion: @escaping (MediaController<TVShow>) -> Void) {
        guard let tvShowId = media.id else { return }
        
        let _ = TMDBClient.shared.getTvShowDetails(id: tvShowId) { result in
            switch result {
            case .success(let tvShow):
                self.media = tvShow
                self.isDetailsLoaded = true
            case .failure(let error):
                self.error = error
            }
            completion(self)
        }
    }
}


//class TVShowController2: MediaController {
//    var isDetailsLoaded: Bool = false
//    
//    var seasons: [Season]? {
//        return tvShow?.seasons ?? nil
//    }
//    var related: [Movie]?
////    var related: [Media]? {
////        return tvShow?.recommendations?.results ?? []
////    }
//    
//    var mediaId: Int?
//    var mediaType: MediaType? = .tvShow
//    var tvShow: TVShow? {
//        didSet { viewModel = TVShowViewModel(tvShow: tvShow!) }
//    }
//    var viewModel: MediaViewModel?
//    var credits: Credits? { return tvShow?.credits }
//    
//    var trailer: VideoResult? {
//        guard let videos = tvShow?.videos?.results,
//              !videos.isEmpty,
//              let video = videos.first(
//                where: { $0.site == "YouTube" && $0.type == "Trailer" })
//        else { return nil }
//        
//        return video
//    }
//
//    
//    var isPosterAvaiable: Bool { return tvShow?.poster_path != nil }
//    var isBackdropAvaiable: Bool { return tvShow?.backdrop_path != nil }
//    
//    var error: Error?
//
//    private func fetchDetails(completion: @escaping (MediaController) -> Void) {
//        guard let tvshowId = mediaId else { return }
//        
//        let _ = TMDBClient.shared.getTvShowDetails(id: tvshowId) { result in
//            switch result {
//            case .success(let tvshow):
//                self.tvShow = tvshow
//                self.isDetailsLoaded = true
//                completion(self)
//            case .failure(let error):
//                self.error = error
//                completion(self)
//            }
//        }
//    }
//    
//    func loadDetails(completion: @escaping (MediaController) -> Void) {
//        fetchDetails(completion: completion)
//    }
//    
//    convenience init(tvShowId: Int) {
//        self.init()
//        self.mediaId = tvShowId
//    }
//    
//    convenience init(tvShow: TVShow) {
//        self.init()
//        self.tvShow = tvShow
//        self.mediaId = tvShow.id
//        self.viewModel = tvShow.viewModel
//    }
//}
