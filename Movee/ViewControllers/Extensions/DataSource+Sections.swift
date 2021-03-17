//
//  DataSource+Sections.swift
//  Movee
//
//  Created by jjurlits on 3/14/21.
//

import UIKit

extension UICollectionViewDiffableDataSource {
    func findSection(at indexPath: IndexPath) -> SectionIdentifierType? {
        return self.snapshot().sectionIdentifiers[indexPath.section]
    }
    
    func findSection(at sectionIndex: Int) -> SectionIdentifierType? {
        return self.snapshot().sectionIdentifiers[sectionIndex]
    }
    
    func findSection(contains item: ItemIdentifierType) -> SectionIdentifierType? {
        return self.snapshot().sectionIdentifier(containingItem: item)
    }
}


extension UITableViewDiffableDataSource {
    func findSection(at indexPath: IndexPath) -> SectionIdentifierType? {
        return self.snapshot().sectionIdentifiers[indexPath.section]
    }
    
    func findSection(at sectionIndex: Int) -> SectionIdentifierType? {
        return self.snapshot().sectionIdentifiers[sectionIndex]
    }
    
    func findSection(contains item: ItemIdentifierType) -> SectionIdentifierType? {
        return self.snapshot().sectionIdentifier(containingItem: item)
    }
}
