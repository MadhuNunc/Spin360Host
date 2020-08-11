//
//  AppDelegate.swift
//  Spin360Host
//
//  Created by apple on 6/11/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import FFSpinSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /**
     * Based on restrict rotation flag, app behaves as required orientaion.
     */
    @objc public var rotateOrientation: Bool = false;

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.rotateOrientation {
            return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.landscape.rawValue)
        } else {
            return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.portrait.rawValue)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FFHelper.app.updateVehicleStatusInprogressToFailedInDB()
        // Update FFSpinSDK Database by calling below function.
        FFSpinManager.sharedService().updateFFSpinSDKDB()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FFHelper.app.cleanup(photoRetentionPeriod: 1)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

