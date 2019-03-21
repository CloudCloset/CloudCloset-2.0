//
//  AppDelegate.swift
//  WeatherDresser
//
//  Created by Lily Li on 7/5/17.
//  Copyright © 2017 Lily Li. All rights reserved.
//
import Firebase
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //        Weather.reload()
        FirebaseApp.configure()
        configureInitialRootViewController(for: window)
        
        //this only runs when app starts
        
        
        do { ///doing this just once when app launches
            if let xmlUrl = Bundle.main.url(forResource: "Dynamite_Clothing-Dynamite_US_Google_Product_Feed-shopping 2", withExtension: "xml") {     //in the future access from Firebase storage
                
                //TO DO:
                //XML TO JSON, CHECK FIREBASE DATABASE STORAGE LIMITS, JSON TO FIREBASE JUST ONCE BACKEND
                //XML TO JSON TO FIREBASE IN CLOUD. NOT WHEN APP LAUNCHES
                
                
                let xml = try String(contentsOf: xmlUrl)
                let clothesParser = ClothesParser(withXML: xml)
                let clothes = clothesParser.parse()
                
                
                let hotWords:[String] = ["crop", "sun", "hot", "summer", "sexy", "short", "wow", "beach", "sandal"]
                let medWords:[String] = ["layer", "spring", "warm", "light", "autumn", "fall", "3/4", "flower", "dress", "day"]
                let coldWords:[String] = ["jeans", "jacket", "blazer", "winter", "long", "rain", "wind", "cold", "snow", "night", "evening", "cozy", "sweater"]
                
                
                for item in clothes {
                    
                    if medWords.contains(where: item.longDesc.contains) { ///AASSIGNNN DIFF TEMP VARIABLES HERE
                        // hot -->  picString & xmlID & clothingType
                        
                        item.temp = "Moderate"
                        WeatherViewController.MEDoutfitsArray.append(item)
                        
                    }
  
                    else if coldWords.contains(where: item.longDesc.contains) { ///AASSIGNNN DIFF TEMP VARIABLES HERE
                        
                        item.temp = "Cold"
                        WeatherViewController.COLDoutfitsArray.append(item)
                        
                    }
                    else if hotWords.contains(where: item.longDesc.contains) { ///AASSIGNNN DIFF TEMP VARIABLES HERE
                        
                        item.temp = "Hot"
                        WeatherViewController.HOToutfitsArray.append(item)
                        
                    }
                        
                        
                    else {
                        
                        item.temp = "Moderate"
                        WeatherViewController.MEDoutfitsArray.append(item)
                    }
                    
                    
                    
                    
                    WeatherViewController.outfitsArrayAll.append(item)
                    
                }
            }
        }
        catch {
            print(error)
        }
        
        
        
        
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow?) {
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if Auth.auth().currentUser != nil,
            let userData = defaults.object(forKey: Constants.UserDefaults.currentUser) as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User {
            
            User.setCurrent(user)
            
            initialViewController = UIStoryboard.initialViewController(for: .main)
            Weather.reload()
        } else {
            initialViewController = UIStoryboard.initialViewController(for: .login)
        }
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}
