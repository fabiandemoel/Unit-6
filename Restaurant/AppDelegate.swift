//
//  AppDelegate.swift
//  Restaurant
//
//  Created by Fabian de Moel on 02/12/2018.
//  Copyright © 2018 Fabian de Moel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var orderTabBarItem: UITabBarItem!
    
    @objc func updateOrderBadge() {
        switch MenuController.shared.order.menuItems.count {
        case 0:
            orderTabBarItem.badgeValue = nil
        case let count:
            orderTabBarItem.badgeValue = String(count)
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set cache size
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: temporaryDirectory)
        URLCache.shared = urlCache
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuController.orderUpdatedNotification, object: nil)
        
        orderTabBarItem = (self.window!.rootViewController! as! UITabBarController).viewControllers![1].tabBarItem
        
        return true
    }
}

