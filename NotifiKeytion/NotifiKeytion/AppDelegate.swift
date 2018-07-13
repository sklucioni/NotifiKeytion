//
//  AppDelegate.swift
//  NotifiKeytion
//
//  Created by Sarah Lucioni on 11/30/17.
//  Copyright © 2017 Sarah Lucioni. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Set navigation bar color
        UINavigationBar.appearance().barTintColor = UIColor(red:0.78, green:0.87, blue:1.00, alpha:1.0)
        
        // Set navigation font
        let navigationFontAttributes = [NSAttributedStringKey.font : UIFont(name: "Futura-Medium", size: 28)!]
        let navigationFontAttributesButtons = [NSAttributedStringKey.font : UIFont(name: "Futura-Medium", size: 18)!]
        
        UINavigationBar.appearance().titleTextAttributes = navigationFontAttributes
        UIBarButtonItem.appearance().setTitleTextAttributes(navigationFontAttributesButtons, for: .normal)
        
        // Set Label font
        UILabel.appearance().font =  UIFont(name: "Futura-Medium", size: 28)
        
        // Override point for customization after application launch.
        return true
    }

    // State restoration help from https://www.raywenderlich.com/117471/state-restoration-tutorial
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        NSLog("we are in the background...")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        NSLog("we terminated...")
    }
}

