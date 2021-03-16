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
    
    var reviews: [Review] {
        return media.reviews?.results ?? []
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
