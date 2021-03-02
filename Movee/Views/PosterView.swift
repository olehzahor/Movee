//
//  PosterView.swift
//  Movee
//
//  Created by jjurlits on 12/27/20.
//

import UIKit


class PosterView: UIView {
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sd_imageTransition = .fade
        imageView.image = UIImage(named: "placeholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let ratingView: RatingView = {
        let view = RatingView()
        view.ratingLabel.font = .systemFont(ofSize: 8, weight: .semibold)
        
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        return view
    }()
        
    func setRating(_ rating: Double, votes: Int! = 0) {
        ratingView.setRating(rating, votes: votes)
    }
    
    func setupViews() {
        addSubview(imageView)
        addSubview(ratingView)
        imageView.fillSuperview()
        ratingView.anchor(top: nil, leading: nil, bottom: imageView.bottomAnchor, trailing: imageView.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 3, right: 3))
        
        addSubview(placeholderLabel)
        placeholderLabel.centerInSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
