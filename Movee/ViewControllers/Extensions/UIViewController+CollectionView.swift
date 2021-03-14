//
//  UIViewController+CollectionView.swift
//  Movee
//
//  Created by jjurlits on 3/14/21.
//

import UIKit

extension UIViewController {
    func createCollectionView(layout: UICollectionViewLayout) -> UICollectionView {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }
}
