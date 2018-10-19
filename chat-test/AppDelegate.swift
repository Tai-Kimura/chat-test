//
//  AppDelegate.swift
//  SwiftTraining
//
//  Created by 木村太一朗 on 2018/10/10.
//  Copyright © 2018年 TANOSYS, LLC. All rights reserved.
//

import UIKit
import SwiftJsonUI
import SimpleApiNetwork
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SimpleApiNetwork.HttpHost = "http://localhost:3000"
        Downloader.clearnUpCachePathIfNeeded()
        SJUIViewCreator.copyResourcesToDocuments()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.backgroundColor = UIColor.white
        UIApplication.shared.applicationIconBadgeNumber = -1
        let topVC: UIViewController = ChatViewController()
        self.window!.rootViewController = topVC
        self.window!.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        #if DEBUG
        HotLoader.instance.isHotLoadEnabled = false
        #endif
        ChatManager.instance.isChatEnabled = false
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        #if DEBUG
        HotLoader.instance.isHotLoadEnabled = false
        #endif
        ChatManager.instance.isChatEnabled = false
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        #if DEBUG
        HotLoader.instance.isHotLoadEnabled = true
        #endif
        let notification = NSNotification.Name("applicationWillEnterForeground")
        NotificationCenter.default.post(name: notification, object: self)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        #if DEBUG
        HotLoader.instance.isHotLoadEnabled = true
        #endif
        let notification = NSNotification.Name("applicationDidBecomeActive")
        NotificationCenter.default.post(name: notification, object: self)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        #if DEBUG
        HotLoader.instance.isHotLoadEnabled = false
        #endif
        ChatManager.instance.isChatEnabled = false
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "chat_test")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}


