//
//  HorizontalMovieCell.swift
//  Movee
//
//  Created by jjurlits on 11/24/20.
//

import UIKit

class HorizontalMovieCell: ProgrammaticCollectionViewCell {
    let poster: PosterView = {
        let posterView = PosterView()
        posterView.layer.cornerRadius = 15
        posterView.clipsToBounds = true
        return posterView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Movie"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .ultraLight)
        label.numberOfLines = 0
        label.backgroundColor = .init(white: 0, alpha: 0.5)
        return label
    }()
    
    override func setupViews() {
        addSubview(poster)
        addSubview(titleLabel)
        
        poster.fillSuperview()
        titleLabel.fillSuperview()
    }
}
