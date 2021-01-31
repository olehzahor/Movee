//
//  MoviesViewController+Layout.swift
//  Movee
//
//  Created by jjurlits on 12/6/20.
//

import UIKit

extension MoviesListViewController {
    func createLayout() -> UICollectionViewLayout {
        let width = view.bounds.width
        let minimalWidth = CGFloat(414.0)
        
        let columnsCount = Int(width / minimalWidth) + 1
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let movieItem = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(182))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: movieItem, count: columnsCount)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
