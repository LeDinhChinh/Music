//
//  AppDelegate.swift
//  Music
//
//  Created by Admin on 2/19/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseName: String = "FavoriteTracks.db"
    var databasePath: String = ""
    class var sharedInstance: AppDelegate {
        struct Singleton {
            static let instance = UIApplication.shared.delegate as! AppDelegate
        }
        return Singleton.instance
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        createAndCheckDatabase()
        return true
    }
    
    func createAndCheckDatabase() {
        var success: Bool = false
        let fileManagere = FileManager.default
        let documentPaths: NSArray = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
        guard let documentPathsFirstObject = documentPaths.firstObject as? String else {
            return
        }
        
        self.databasePath = documentPathsFirstObject + "/" + self.databaseName
        success = fileManagere.fileExists(atPath: databasePath)
        if success {
            print(databasePath)
            return
        }
        
        guard let resourcePath = Bundle.main.resourcePath else {
            return
        }
        let databasePathFromApp: String = resourcePath + "/" + databaseName
        do {
            try fileManagere.copyItem(atPath: databasePathFromApp, toPath: databasePath)
            print("Ok")
        } catch {
            
        }
    }
}

