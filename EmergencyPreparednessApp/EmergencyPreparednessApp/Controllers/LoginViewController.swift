//
//  LoginViewController.swift
//  EmergencyPreparednessApp
//
//  Created by Steven Dai on 2019-02-07.
//  Copyright © 2019 IBM. All rights reserved.
//

import Foundation
import UIKit

let loginSuccessfulNotificationName = Notification.Name("loginSuccessful")

class LoginViewController: BaseViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessful), name: loginSuccessfulNotificationName, object: nil)
        authWithAutoCodeExchange()
    }
    
    @objc func loginSuccessful()
    {
        AppController.shared.loadHomePage()
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func retry(_ sender: UIButton)
    {
        authWithAutoCodeExchange()
    }
}
