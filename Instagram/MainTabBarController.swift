//
//  MainTabBarController.swift
//  Instagram
//
//  Created by takuyaOhmuro on 2018/05/21.
//  Copyright © 2018年 takuyaOhmuro. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: userProfileController)
        
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
        navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        tabBar.tintColor = .black
        
        viewControllers = [navController,UIViewController()]
    }
}
