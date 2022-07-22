//
//  Coordinator.swift
//  learn.ui.kit
//
//  Created by ghtk on 01/07/2022.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}


class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let mainVC = MainViewController()
        mainVC.coordinator = self
    
        navigationController.pushViewController(mainVC, animated: true)
    }
    
    func goToLogin(delegate: PinkViewDelegate?) {
        let pinkVC = PinkViewController()
        
        pinkVC.delegate = delegate
        navigationController.pushViewController(pinkVC, animated: true)
    }
    
    func goToImageDetail(musicData: Music) {
        let detailVC = DetailViewController()
        detailVC.data = musicData
        navigationController.pushViewController(detailVC, animated: true)
    }
}
