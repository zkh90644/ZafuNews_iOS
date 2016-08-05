//
//  AppDelegate.swift
//  ZafuNews
//
//  Created by zkhCreator on 7/9/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

let APPKEY = "1593827671498"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
//        创建VC
        window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.init(red: 68/255.0, green: 138/255.0, blue: 255/255.0, alpha: 1)
        
        let basicVC = ZNMainViewController()
        
        window?.rootViewController = basicVC
        
//        获取本地存储的天气
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first
        path?.appendContentsOf("/weather.plist")
        
        let manager = NSFileManager.defaultManager()
        if manager.fileExistsAtPath(path!) {
            //        获得天气
            let weatherDic = NSDictionary.init(contentsOfFile: path!)
            
            let weatherView = basicVC.leftBarView.leftView.weatherView
            weatherView.date.text = (weatherDic!["date"] as! String)
            weatherView.currentTem.text = (weatherDic!["tmp"] as! String)
            weatherView.position.text = (weatherDic!["position"] as! String)
            weatherView.weatherInterval.text = "AQI:"+(weatherDic!["AQI"] as! String)
            weatherView.weatherImageView.image = UIImage.init(data: weatherDic!["weather"] as! NSData)
            weatherView.temInterval.text = (weatherDic!["minToMax"] as! String)
        }else{
            let weatherView = basicVC.leftBarView.leftView.weatherView
            weatherView.date.text = "0"
            weatherView.currentTem.text = "0"
            weatherView.position.text = "您还没获取呐"
            weatherView.weatherInterval.text = "AQI:0"
            weatherView.weatherImageView.image = UIImage.init(named: "sunny")
            weatherView.temInterval.text = "0"
        }
        
        
        return true
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

