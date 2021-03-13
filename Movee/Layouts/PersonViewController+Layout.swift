//
//  PersonController+Layout.swift
//  Movee
//
//  Created by jjurlits on 12/1/20.
//

import UIKit

extension PersonViewController {
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let snapshot = self?.snapshot else { return nil }
            let section = snapshot.sectionIdentifiers[sectionIndex]
            switch section {
            case .photoAndName:
                return GenericLayouts.createFullWidthSection()
            case .personalInfo, .biography:
                return GenericLayouts.createFullWidthSection(addHeader: true)
            case .knownFor:
                return GenericLayouts.createHorizontalListSection(height: 226, width: 110, addHeader: true)
            }
        }
    }
}
