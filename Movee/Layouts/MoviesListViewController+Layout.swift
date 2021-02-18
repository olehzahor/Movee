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
        
        let columnsCount = 1
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let movieItem = NSCollectionLayoutItem(layoutSize: itemSize)
        movieItem.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(182))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: movieItem, count: columnsCount)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
