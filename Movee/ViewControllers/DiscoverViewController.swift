//
//  CVDiscoverVC.swift
//  Movee
//
//  Created by jjurlits on 3/19/21.
//

import UIKit

class DiscoverViewController: UIViewController, Coordinated {
    weak var coordinator: SearchCoordinator?
    var collectionView: UICollectionView!
    
    lazy var dataSource = createDataSource()
    
    var discoverController: DiscoverController!
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    override func viewDidLoad() {
        collectionView = createCollectionView(layout: createLayout())
        collectionView.delegate = self
        
        collectionView.registerCell(DiscoverListItemCell.self)
        collectionView.registerHeader(SectionHeader.self)
        
        discoverController.loadData(completion: update)
        title = discoverController.name
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func move(toList list: AnyHashable?) {
        guard let list = list as? DiscoverListItem else { return }
        if let controller = list.mediaController {
            coordinator?.showCustomMediaList(mediaController: controller)
        } else {
            coordinator?.showNestedDiscoverList(
                discoverController: discoverController.moved(to: list))
        }
    }
    
    func createSnapshot() -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        let items = Item.createItems(from: discoverController) { self.move(toList: $0) }
        snapshot.appendItems(items)
        return snapshot
    }

}

extension DiscoverViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource.itemIdentifier(for: indexPath)?.act()
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
}

extension DiscoverViewController {
    @objc func update() {
        dataSource.apply(createSnapshot())
    }
    
    func createDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let cell = collectionView.dequeueCell(DiscoverListItemCell.self, for: indexPath)
            cell.titleLabel.text = item.title
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let section = self?.dataSource.findSection(at: indexPath) else { return nil }
            
            let header = collectionView.dequeueHeader(SectionHeader.self, for: indexPath)
            header.titleLabel.text = section.title
            return header
        }
        
        return dataSource
    }
}

extension DiscoverViewController {
    enum Section: Hashable {
        case main, custom(String)
        var title: String {
            switch self {
            case .custom(let title):
                return title
            default:
                return ""
            }
        }
    }
    
    struct Item: Hashable {
        typealias ActionClosure = (AnyHashable?) -> Void
        var title: String
        var action: ActionClosure?
        var item: AnyHashable?
        
        func act() {
            action?(item)
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(title)
        }
        
        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.title == rhs.title
        }
        
        static func createItems(from controller: DiscoverController, action: ActionClosure?) -> [Item] {
            return controller.lists.compactMap {
                Item(title: $0.localizedName, action: action, item: $0)
            }
        }
    }
}
