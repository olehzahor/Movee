//
//  MediaController.swift
//  Movee
//
//  Created by jjurlits on 2/25/21.
//

import Foundation

class MediaController<T: Media> {
    var media: T
    
    var viewModel: MediaViewModel? {
        return AnyMediaViewModel(media: media)
    }
    
    var error: Error?
    var isDetailsLoaded: Bool = false
        
    var related: [T]? { return nil }
    var seasons: [Season]? { return nil }
    
    var trailer: VideoResult? {
        if let videos = media.videos?.results, !videos.isEmpty {
            return videos.first(where: { $0.site == "YouTube" && $0.type == "Trailer" })
        } else { return nil }
    }

    
    var credits: Credits? {
        return media.credits
    }

    var isPosterAvaiable: Bool {
        return media.poster_path != nil
    }
    
    var isBackdropAvaiable: Bool {
        return media.backdrop_path != nil
    }
    
    func loadDetails(completion: @escaping (MediaController<T>) -> Void) { }

    init(_ media: T) {
        self.media = media
    }
}




//protocol MediaController {
//    var mediaId: Int? { get }
//    var mediaType: MediaType? { get }
//    var viewModel: MediaViewModel? { get }
//    var error: Error? { get set }
//
//    var credits: Credits? { get }
//    var related: [Movie]? { get }
//    var seasons: [Season]? { get }
//    var trailer: VideoResult? { get }
//    var isPosterAvaiable: Bool { get }
//    var isBackdropAvaiable: Bool { get }
//
//    var isDetailsLoaded: Bool { get }
//
//    func loadDetails(completion: @escaping (MediaController) -> Void)
//}
