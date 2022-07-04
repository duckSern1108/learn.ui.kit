//
//  HomeViewController.swift
//  learn.ui.kit
//
//  Created by ghtk on 04/07/2022.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onCreateNavigationController(_ sender: Any) {
        let navigationController = UINavigationController()
        let coordinator = MainCoordinator(navigationController: navigationController)
        coordinator.start()
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        scene?.window?.rootViewController = navigationController
        scene?.window?.makeKeyAndVisible()
    }
    
    @IBAction func onCreateTabbarController(_ sender: Any) {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .red
        let blackVC = BlackViewController()
        blackVC.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        let loadingVC = LoadingViewController()
        loadingVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        loadingVC.tabBarItem.badgeValue = "99+"
        loadingVC.tabBarItem.badgeColor = .blue

        tabBarController.viewControllers = [blackVC, loadingVC]
        
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        scene?.window?.rootViewController = tabBarController
        scene?.window?.makeKeyAndVisible()
    }
}
