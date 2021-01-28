//
//  GenericCollectionViewController.swift
//  Movee
//
//  Created by jjurlits on 12/1/20.
//

import UIKit



protocol GenericCollectionViewController: class {
//    associatedtype SectionIdentifierType: Hashable
//    associatedtype ItemIdentifierType: Hashable
//
//    var dataSource: DataSource? { get set }
    var collectionView: UICollectionView! { get set }
    func createCollectionView() -> UICollectionView
    //func setupCollectionView()
    func createLayout() -> UICollectionViewLayout
    func registerCell<T: SelfConfiguringView>(_ cellClass: T.Type)
    func dequeueCell<T: SelfConfiguringView>(_ cellClass: T.Type, for indexPath: IndexPath) -> T
    func registerHeader<T: SelfConfiguringView>(_ viewClass: T.Type)
    func dequeueHeader<T: SelfConfiguringView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T
    func registerFooter<T: SelfConfiguringView>(_ viewClass: T.Type)
    func dequeueFooter<T: SelfConfiguringView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T
}

extension GenericCollectionViewController where Self: UIViewController {
    func createCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }
    
    func findSection<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>
    (
        at indexPath: IndexPath,
        in dataSource: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>?
    ) -> SectionIdentifierType? {
        return dataSource?.snapshot().sectionIdentifiers[indexPath.section]
        //return sections[indexPath.section]
    }
    
    func findSection<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>
    (
        at sectionIndex: Int,
        in dataSource: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>?
    ) -> SectionIdentifierType? {
        return dataSource?.snapshot().sectionIdentifiers[sectionIndex]
        //return sections[indexPath.section]
    }
    
    
    func findSection<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>(
        contains item: ItemIdentifierType,
        in dataSource: UICollectionViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>?
    ) -> SectionIdentifierType? {
        return dataSource?.snapshot().sectionIdentifier(containingItem: item)
    }
    
    func f<SectionIdentifierType: Hashable, ItemIdentifierType: Hashable>(dataSource: UITableViewDiffableDataSource<SectionIdentifierType, ItemIdentifierType>) {
        
    }
    
    func registerCell<T: SelfConfiguringView>(_ cellClass: T.Type) {
        collectionView.register(
            cellClass,
            forCellWithReuseIdentifier: cellClass.reuseIdentifier
        )
    }

    func dequeueCell<T: SelfConfiguringView>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellClass.reuseIdentifier,
                for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue \(cellClass)")
        }
        return cell
    }
    
    func registerHeader<T: SelfConfiguringView>(_ viewClass: T.Type) {
        collectionView.register(
            viewClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: viewClass.reuseIdentifier
        )
    }

    func dequeueHeader<T: SelfConfiguringView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: viewClass.reuseIdentifier,
                for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue header \(viewClass)")
        }
        return header
    }
    
    func registerFooter<T: SelfConfiguringView>(_ viewClass: T.Type) {
        collectionView.register(
            viewClass,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: viewClass.reuseIdentifier
        )
    }
    
    func dequeueFooter<T: SelfConfiguringView>(_ viewClass: T.Type, for indexPath: IndexPath) -> T {
        guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: viewClass.reuseIdentifier,
                for: indexPath
        ) as? T else {
            fatalError("Unable to dequeue footer \(viewClass)")
        }
        return header
    }
    
}
