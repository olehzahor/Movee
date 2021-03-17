//
//  SearchHistoryViewController.swift
//  Movee
//
//  Created by jjurlits on 3/16/21.
//

import UIKit

class SearchHistoryViewController: MediaListViewController {
    @objc func clearHistory() {
        SearchHistoryController.shared.clear()
        coordinator?.getBack()
    }
    
    fileprivate func setupNavigationBarButtons() {
        let clearHistoryButton = UIBarButtonItem(
            image: UIImage(systemName: "trash"),
            style: .plain,
            target: self,
            action: #selector(clearHistory))

        self.navigationItem.rightBarButtonItem = clearHistoryButton
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarButtons()
        
    }
}
