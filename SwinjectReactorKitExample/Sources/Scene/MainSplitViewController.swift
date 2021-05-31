//
//  MainSplitViewController.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/28.
//

import UIKit

final class MainSplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        let masterVC = UINavigationController()
        let detailVC = UINavigationController()
        self.viewControllers = [masterVC, detailVC]
    }
} 

extension MainSplitViewController: UISplitViewControllerDelegate {
//    func splitViewController(
//        _ splitViewController: UISplitViewController, 
//        collapseSecondary secondaryViewController: UIViewController, 
//        onto primaryViewController: UIViewController
//    ) -> Bool {
//        
//    }
}
