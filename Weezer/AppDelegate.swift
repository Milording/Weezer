//
//  AppDelegate.swift
//  Weezer
//
//  Created by Anton on 07/04/2018.
//  Copyright © 2018 milording. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let pageViewController = PageViewController()
        pageViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        let navigationController = UINavigationController(rootViewController: pageViewController)
        navigationController.navigationBar.topItem?.title = "Moscow"
        
        let searchViewController = SearchViewController()
        searchViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let tabBarList = [navigationController, searchViewController]
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = tabBarList
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        return true
    }
}

