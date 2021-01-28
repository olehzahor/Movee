import UIKit
import youtube_ios_player_helper

class TrailerCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    var player: YTPlayerView {
        YoutubePlayer.shared.player
    }
    
    let placeholder: UIImageView = createView {
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.backgroundColor = .secondarySystemBackground
        $0.addOverlay(color: .black, alpha: 0.4)
        //$0.alpha = 0.5
    }
    
    let playButton: UIButton = createView {
        $0.setTitle("▶ Play Trailer", for: .normal)
        $0.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.textColor = .white
    }
    
    let trailerNameLabel: UILabel = createView {
        $0.text = "Trailer"
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    let spinner: UIActivityIndicatorView = createView {
        $0.hidesWhenStopped = true
        $0.color = .white
    }
    
    private var videoId: String?
    
    override func setupViews() {
        addSubview(placeholder)
        placeholder.fillSuperview()
        placeholder.heightAnchor.constraint(equalTo: placeholder.widthAnchor, multiplier: 1/1.85).isActive = true

        
        let vstack = UIStackView(arrangedSubviews: [spinner, playButton, trailerNameLabel])
        vstack.axis = .vertical
        addSubview(vstack)
        vstack.centerInSuperview()
        vstack.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    func setVideo(id: String) {
        if self.videoId != id {
            self.videoId = id
            playButton.addTarget(self, action: #selector(loadVideo), for: .touchUpInside)
        }
    }
    
    @objc func loadVideo() {
        player.removeFromSuperview()
        addSubview(player)
        player.fillSuperview()
        
        if let videoId = videoId {
            spinner.startAnimating()
            YoutubePlayer.shared.setVideo(id: videoId) {_ in
                self.spinner.stopAnimating()
            }
            
        }
    }
}
