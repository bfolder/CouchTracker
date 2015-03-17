//
//  AppDelegate.swift
//  CouchTracker
//
//  Created by Heiko Dreyer on 03/12/15.
//  Copyright (c) 2015 boxedfolder.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    let databaseName = "expenses"
    let manager: CBLManager =  CBLManager.sharedInstance()
    
    lazy var database: CBLDatabase = {
        return self.manager.databaseNamed(self.databaseName, error: nil)
    }()
    
    
    struct Colors {
        static let Green = UIColor(red: 0.572, green: 0.764, blue: 0.286, alpha: 1.0)
        static let Red = UIColor(red: 0.764, green: 0.286, blue: 0.286, alpha: 1.0)
    }
    
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let budgetListViewController = BudgetListViewController()
        budgetListViewController.database = database
        budgetListViewController.manager = manager
        window!.rootViewController = UINavigationController(rootViewController: budgetListViewController);
        window!.tintColor = Colors.Green
        window!.backgroundColor = UIColor.whiteColor()
        window!.makeKeyAndVisible()
        
        return true
    }
}

