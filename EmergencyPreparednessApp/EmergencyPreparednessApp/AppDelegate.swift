//
//  AppDelegate.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-16.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import UserNotificationsUI
import BMSCore
import BMSPush
import AppAuth
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, BMSPushObserver {

    var window: UIWindow?
    var currentAuthorizationFlow: OIDExternalUserAgentSession?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppCenter.start(withAppSecret: "3e477e22-ab45-4479-ae0e-2e3323e97107", services:[
          Analytics.self,
          Crashes.self
        ])
        resetIfRequired()
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            self.handleNotification(notification: notification)
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        //UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        AppController.shared.loadAlertWarning()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        if let accepted = AppController.shared.termsAndConditons, Constants.AcceptedTermsAndConditions == accepted {
            
                if KeychainManager.shared.isUserLoggedIn {
                    AppController.shared.loadHomePage()
                }
        }else{
            // remove old token if it exists
            _ = KeychainManager.shared.removeToken()
            
            // pops up the terms and conditons
            AppController.shared.loadTermsAndConditionPage()
        }
        
       
        //EmailValidationService().validateEmail(emailId: "janice.lobo@ibm.com",token: "11467", completion: {success in print(success)})
        return true
    }
    
    func registerForPushNotifications() {
        BMSPushClient.sharedInstance.delegate = self
        BMSClient.sharedInstance.initialize(bluemixRegion: BMSClient.Region.usSouth)
        BMSPushClient.sharedInstance.initializeWithAppGUID(appGUID: Constants.BMSAppGUID,
                                                           clientSecret:Constants.BMSClientSecret)
    }
    
    func handleNotification(notification:[String:AnyObject?]){
        let respJson = (notification as NSDictionary).value(forKey: "payload") as? String
        let data = respJson?.data(using: String.Encoding.utf8)
        let jsonResponse:NSDictionary = try! JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        let messageId:String = jsonResponse.value(forKey: "nid") as! String
        
        let payLoad = ((((notification as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! NSString)
        let currentDate = Date()
        let alertMessage = AlertMessage(content: payLoad as String, alertId: messageId, receivedDate: AppController.shared.getStringFromDate(theDate: currentDate))

        AppController.shared.saveAlertItem(alertItem: alertMessage)
        
        NotificationCenter.default.post(name:Notification.Name(rawValue:Constants.pushNotificationReceived),
                                        object: nil,
                                        userInfo: nil)
    }
    
    func showAlert (title:NSString , message:NSString){
        
        // create the alert
        let alert = UIAlertController.init(title: title as String, message: message as String, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.window!.rootViewController!.present(alert, animated: true, completion: nil)
    }
    
    func application (_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        BMSPushClient.sharedInstance.registerWithDeviceToken(deviceToken: deviceToken) { (response, statusCode, error) -> Void in
            if error.isEmpty {
                print( "Response during device registration: \(String(describing: response)) and status code is:\(String(describing: statusCode))")
            } else{
                print( "Error during device registration: \(error) and status code is: \(String(describing: statusCode))")
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
            handleBMSNotification(notification: userInfo)
    }
    
    func handleBMSNotification(notification:[AnyHashable:Any]){
        
        let push =  BMSPushClient.sharedInstance
        
        let respJson = (notification as NSDictionary).value(forKey: "payload") as! String
        let data = respJson.data(using: String.Encoding.utf8)
        
        let jsonResponse:NSDictionary = try! JSONSerialization.jsonObject(with: data! , options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
        print(jsonResponse)
        let payLoad = ((((notification as NSDictionary).value(forKey: "aps") as! NSDictionary).value(forKey: "alert") as! NSDictionary).value(forKey: "body") as! NSString)
        
        
        //self.showAlert(title: "Alert", message: payLoad)
        let messageId:String = jsonResponse.value(forKey: "nid") as! String
        //let content = jsonResponse.value(forKey: "content")
        push.sendMessageDeliveryStatus(messageId: messageId) { (res, ss, ee) in
            print("Send message status to the Push server")
        }
        let currentDate = Date()
        let alertMessage = AlertMessage(content: payLoad as String, alertId: messageId, receivedDate: AppController.shared.getStringFromDate(theDate: currentDate))
        
        AppController.shared.saveAlertItem(alertItem: alertMessage)
        AppController.shared.insertAlertItem(alertItem: alertMessage)
        AppController.shared.saveAlertsList()
        NotificationCenter.default.post(name:Notification.Name(rawValue:Constants.pushNotificationReceived),
                                        object: nil,
                                        userInfo: nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func registerForUserNotification(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: {
            granted, error in
            if granted{
                print("Registerd for local notifications")
            }else{
                print("Local notification registration failed")
            }
            
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        print("Tapped in notification")
        if response.notification.request.identifier == Constants.renewalNotification{
            AppController.shared.loadLoginPage()
        }else{
            self.handleBMSNotification(notification: response.notification.request.content.userInfo)
        }
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        print("Notification being triggered")
    
        completionHandler([UNNotificationPresentationOptions.alert,
                           UNNotificationPresentationOptions.sound,
                           UNNotificationPresentationOptions.badge])
        print("Notification body: \(notification.request.content.body)")
        
        if notification.request.identifier == Constants.renewalNotification{
            emailRevalidationAlert()
        }else{
            self.handleBMSNotification(notification: notification.request.content.userInfo)
        }
        
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications

    }
    
    func onChangePermission(status: Bool) {
        if status{
            print("Granted...")

        }else{
            print("Not granted...")
        }
    }
     func emailRevalidationAlert(){
        let alert = UIAlertController(title: "Attention", message: "Your subscription has expired. Please revalidate your email.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: presentRegistrationPage))
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func presentRegistrationPage(action:UIAlertAction){
        AppController.shared.loadLoginPage()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        AppController.shared.saveAlertsList()
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
        
        AppController.shared.saveAlertsList()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // this doesn't get called with the AppAuth framework but it's left in as a fallback
        if let auth = AuthenticationType(rawValue: url.absoluteString)
        {
            auth.handleAuthentication() // get the token from the response
            return true
        }
        return false
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "EmergencyPreparednessApp")
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

