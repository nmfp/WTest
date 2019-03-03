//
//  MainTabBarController.swift
//  WTest
//
//  Created by Nuno Pereira on 01/03/2019.
//  Copyright © 2019 Nuno Pereira. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        let zipcodesController = setupViewController(with: "Zipcodes", iconTitle: "Zipcodes", iconImage: #imageLiteral(resourceName: "mailbox"), rootViewController: ZipcodesController())
        let textFieldListController = setupViewController(with: "TextField List", iconTitle: "Ex3", iconImage: nil, rootViewController: TextFieldListController())
        let webController = setupViewController(with: "Web", iconTitle: "Ex4", iconImage: nil, rootViewController: WebController())
        viewControllers = [
            zipcodesController,
            textFieldListController,
            webController
        ]
    }
    
    private func setupViewController(with title: String, iconTitle: String, iconImage: UIImage?, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        rootViewController.tabBarItem.title = title
        rootViewController.tabBarItem.image = iconImage
        rootViewController.tabBarItem.selectedImage = iconImage
        rootViewController.title = iconTitle
        return UINavigationController(rootViewController: rootViewController)
    }
    
}
