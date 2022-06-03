//
//  AppController.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-16.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class AppController: NSObject {
    static let shared = AppController()
    
    var termsAndConditons = UserDefaults.standard.value(forKey: "TermsAndConditions") as? String
    var alertsList: [AlertMessage]?
    var alertWarning: AlertMessage?
    
    var storyboard: UIStoryboard{
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    private override init() {
        super.init()

    }
    
    public func loadHomePage(){
        setupControllers("HomePageNavId", viewController: UINavigationController.self)
    }
    
    public func loadTermsAndConditionPage(){
        setupControllers("TermsAndConditions", viewController: TermsAndConditionsViewController.self)
    }
    
    public func loadLoginPage(){
        setupControllers("LoginViewController", viewController: LoginViewController.self)
    }
    
    
    private func setupControllers <T: UIViewController> (_ indentifier: String, viewController: T.Type){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStoryboard = storyboard
        let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: indentifier) as! T
        appDelegate.window?.rootViewController = initialViewController
        appDelegate.window?.makeKeyAndVisible()
    
    }
    
    
    public func makePhoneCall(phoneNumber: String){
        if let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }else{
            print("Cannot make phone call")
        }
    }
    
    public func saveValidationToken(token:String){
        UserDefaults.standard.set(token, forKey: Constants.emailValidationTokenKey)
    }
    
    public func getValidationToken()->String? {
        let token = UserDefaults.standard.value(forKey: Constants.emailValidationTokenKey) as? String
        return token
    }
    
    public func saveAlertItem(alertItem:AlertMessage){
        self.alertWarning = alertItem
        if let alertWaring = self.alertWarning{
            let data = NSKeyedArchiver.archivedData(withRootObject: alertWaring)
            UserDefaults.standard.set(data, forKey: Constants.alertItemId)
        }
    }
    
    public func loadAlertWarning(){
        if let data = UserDefaults.standard.object(forKey: Constants.alertItemId) as? Data{
            let unarc = NSKeyedUnarchiver(forReadingWith: data)
            alertWarning = unarc.decodeObject(forKey: "root") as? AlertMessage
        }
        
    }
    
    public func deleteAlertItem(){
        UserDefaults.standard.removeObject(forKey: Constants.alertItemId)
        alertWarning = nil
    }
    
    public func insertAlertItem(alertItem: AlertMessage?){
        if let alertItem = alertItem{
            if alertsList != nil{
                self.alertsList?.append(alertItem)
            }else{
                self.alertsList = [alertItem]
            }
        }
    }
    
    public func saveAlertsList(){
        
        if let alertList = alertsList{
            let defaults = UserDefaults.standard
            let data = NSKeyedArchiver.archivedData(withRootObject: alertList)
            defaults.set(data, forKey: Constants.alertsListId)
        }
    }
    
    public func getStringFromDate(theDate: Date?)->String?{
        if let theDate = theDate{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy hh:mm:ss"
            return dateFormatter.string(from: theDate)
        }else{
            return nil
        }
    }
    
    public func loadAlertsList(){
        if let data = UserDefaults.standard.object(forKey: Constants.alertsListId) as? NSData {
            alertsList = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? [AlertMessage]
        }
    }
}
