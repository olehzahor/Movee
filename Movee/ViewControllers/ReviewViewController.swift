//
//  ReviewViewController.swift
//  Movee
//
//  Created by jjurlits on 3/15/21.
//

import UIKit

class ReviewViewController: UIViewController, Coordinated {
    weak var coordinator: MainCoordinator?
        
    var review: Review?
    
    override func viewDidLoad() {
        let textView = UITextView()
        textView.isEditable = false
        textView.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        view = textView
        textView.attributedText = review?.viewModel.attributedContent
    }
}
