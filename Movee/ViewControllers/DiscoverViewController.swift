//
//  ExploreViewController.swift
//  Movee
//
//  Created by jjurlits on 12/11/20.
//

import UIKit

//class DiscoverViewController: UITableViewController, Coordinated {
//    var coordinator: MainCoordinator?
//    
//    typealias DataSource = UITableViewDiffableDataSource<String, DiscoverController.List>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<String, DiscoverController.List>
//    
//    private(set) lazy var dataSource = createDataSource()
//    var discoverController: DiscoverController!
//    
//    override func viewDidLoad() {
//        title = "Discover"
//        if discoverController == nil {
//            //discoverController = DiscoverController()
//        }
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
//        dataSource.apply(createSnapshot())
//    }
//    
//    func createDataSource() -> DataSource {
//        let dataSource = DataSource(tableView: tableView) { (tableView, indexPath, list) -> UITableViewCell? in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//            cell.textLabel?.text = list.title
//            cell.accessoryType = .disclosureIndicator
//            return cell
//        }
//        
//        return dataSource
//    }
//    
//    func createSnapshot() -> Snapshot {
//        var snapshot = Snapshot()
//        snapshot.appendSections(["Main"])
//        snapshot.appendItems(discoverController.lists)
//        return snapshot
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let list = dataSource.itemIdentifier(for: indexPath) else { return }
//        if list.isNested {
//            let vc = DiscoverViewController()
//            //discoverController.moveTo(nestedLists: list.nestedLists)
//            vc.discoverController = discoverController
//            navigationController?.pushViewController(vc, animated: true)
//        } else {
//            if let controller = list.moviesController {
//                coordinator?.showCustomMoviesList(moviesController: controller)
//            }
//        }
//    }
//}
