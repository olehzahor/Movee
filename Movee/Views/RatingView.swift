//
//  RatingView.swift
//  Movee
//
//  Created by jjurlits on 2/24/21.
//

import UIKit

class RatingView: UIView {
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 8, weight: .semibold)
        
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        
        return label
    }()
    
    func setRating(_ rating: Double, votes: Int! = 0) {
        guard rating > 0 else {
            ratingLabel.text = ""
            return
        }
        
        switch rating {
        case 7...10:
            ratingLabel.backgroundColor = UIColor.green
            ratingLabel.textColor = .darkGray
        case 5..<7:
            ratingLabel.backgroundColor = UIColor.yellow
            ratingLabel.textColor = .darkGray
        case 1..<5.5:
            ratingLabel.backgroundColor = UIColor.orange
            ratingLabel.textColor = .white
        default:
            ratingLabel.backgroundColor = .secondarySystemBackground
        }
        ratingLabel.text = " \(rating) "
        
        if votes > 0 {
            ratingLabel.text?.append("(\(votes ?? 0)) ")
        }
    }
    
    func setupViews() {
        addSubview(ratingLabel)
        ratingLabel.fillSuperview()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
