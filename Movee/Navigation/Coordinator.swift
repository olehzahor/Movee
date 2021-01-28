//
//  Coordinator.swift
//  Movee
//
//  Created by jjurlits on 12/7/20.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}

extension Coordinator {
    private func push(_ vc: UIViewController) {
        navigationController.pushViewController(vc, animated: true)
    }

    internal func createAndPush<T: UIViewController&Coordinated>(_ type: T.Type, animated: Bool! = true, setup: ((T) -> Void)? = nil) {
        let vc = T()
        vc.coordinator = self as? T.CoordinatorType
        setup?(vc)
        push(vc)
    }
}
