//
//  YoutubePlayer.swift
//  Movee
//
//  Created by jjurlits on 12/27/20.
//

import Foundation
import youtube_ios_player_helper

class YoutubePlayer: NSObject, YTPlayerViewDelegate {
    static let shared = YoutubePlayer()
    var autoPlay: Bool = true
    private var completionHandler: ((YoutubePlayer) -> Void)?
    
    private var videoId: String?
    
    func hidePlayer() {
        player.isHidden = true
    }
    
    func showPlayer() {
        player.isHidden = false
    }
    
    lazy var player: YTPlayerView = {
        let player = YTPlayerView()
        player.isHidden = true
        player.delegate = self
        return player
    }()
    
    func setVideo(id: String, completion: ((YoutubePlayer) -> Void)? = nil) {
        if videoId == nil {
            videoId = id
            player.load(withVideoId: id)
        } else if videoId != id {
            videoId = id
            hidePlayer()
            player.cueVideo(byId: id, startSeconds: 0)
        }
        completionHandler = completion
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        start()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .cued {
            start()
        }
    }
    
    private func start() {
        showPlayer()
        completionHandler?(self)
        if autoPlay { player.playVideo() }
    }
}
