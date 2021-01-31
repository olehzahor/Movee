//
//  MovieCell.swift
//  Movee
//
//  Created by jjurlits on 10/27/20.
//

import UIKit

class MovieCell: UICollectionViewCell, SelfConfiguringView {
    let poster = PosterView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    let ratingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "7.6"
        label.backgroundColor = .darkGray
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .center
        
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
                
        return label
    }()
       
    fileprivate func setupViews() {
        [poster, titleLabel, infoLabel, overviewLabel].forEach({addSubview($0)})
        
        poster.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: .init(top: 8, left: 16, bottom: 8, right: 0))
        
        poster.widthAnchor.constraint(equalTo: poster.heightAnchor, multiplier: 2/3).isActive = true
        
        titleLabel.anchor(top: topAnchor, leading: poster.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 8, left: 16, bottom: 0, right: 8))
        
        infoLabel.putBelow(view: titleLabel, spacing: 8)
        
        overviewLabel.putBelow(view: infoLabel, spacing: 8)
        overviewLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8).isActive = true
        overviewLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    
    override init(frame: CGRect) {
        print(MovieCell.reuseIdentifier)
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
