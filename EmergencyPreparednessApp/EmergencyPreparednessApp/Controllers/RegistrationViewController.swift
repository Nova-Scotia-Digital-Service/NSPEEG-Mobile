//
//  RegistrationViewController.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-16.
//  Copyright © 2017 Jubin Jose. All rights reserved.
//

import UIKit
import QuartzCore
import UserNotifications
import UserNotificationsUI
import PKHUD

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var stackViewTopSpacing: NSLayoutConstraint!
    @IBOutlet var sentTokenView: UIView!
    @IBOutlet var unregisteredView: UIView!
    @IBOutlet var tokenInfoLabel: UILabel!
    @IBOutlet var thankYouLabel: UILabel!
    @IBOutlet var mainTextField: UITextField!
    @IBOutlet var enterEmailLabel: UILabel!
    @IBOutlet var appUsageLabel: UILabel!
    @IBOutlet var submitButton: UIButton!
    var emailService = EmailValidationService()
    var token:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        submitButton.layer.cornerRadius = 22.5
        self.token = AppController.shared.getValidationToken()
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        switch AppController.shared.appStatus {
        case .Unregisterd:
            if isValidEmail(emailString: mainTextField.text){
                HUD.show(.progress)
                emailService.validateEmail(emailId: self.mainTextField.text,
                                           token: Utilities.generateRandomDigits(5),
                                           completion: {success in
                                            if success == true{
                                                DispatchQueue.main.async {
                                                    AppController.shared.setAppStatus(theStatus: .ReceivedToken)
                                                    self.mainTextField.text = ""
                                                    self.showReceivedTokenView()
                                                    HUD.hide()
                                                }
                                            }else{
                                                DispatchQueue.main.async {
                                                    HUD.hide()
                                                    self.showValidationFailedAlert()
                                                }
                                            }
                })

            }else{
                showInvalidEmailAlert()
            }
        case .ReceivedToken:
            showReceivedTokenView()
            self.validateToken()
            
        case .ReadyForToken:
            showReadyForTokenView()
            self.validateToken()
            
        default:
            showUregisteredView()
        }
    }

    private func showInvalidEmailAlert(){
        let alert = UIAlertController(title: "Invalid Email",
                                      message: "Please enter a valid email address",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showValidationFailedAlert(){
        let alert = UIAlertController(title: "Warning",
                                      message: "Email validatin failed. Please try again later.",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func validateToken(){
        if let tokenText = self.mainTextField.text{
            if AppController.shared.getValidationToken() == tokenText{
                AppController.shared.setAppStatus(theStatus: .Registerd)
                registerEmailValidattionReminder()
                AppController.shared.loadHomePage()
                print("\(tokenText)")
            }
            else{
                showInvalidTokenAlert()
            }
        }
    }
    
    private func registerEmailValidattionReminder(){
        let notification = UNMutableNotificationContent()
        notification.title = "Attention!"
        notification.body = "Your subscription has expired. Please revalidate your email."
        notification.sound = UNNotificationSound.default
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: Constants.subscriptionRenewalInterval, repeats: false)
        let request = UNNotificationRequest(identifier: Constants.renewalNotification,
                                            content: notification,
                                            trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func showInvalidTokenAlert(){
        let alert = UIAlertController(title: "Invalid Token", message: "Please enter a valid token", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func isValidEmail(emailString:String?) -> Bool {
        if let emailString = emailString{
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if true == emailTest.evaluate(with: emailString) && ((emailString.lowercased().range(of:"@novascotia.ca") != nil)||(emailString.lowercased().range(of:"@ibm.com") != nil) || (emailString.lowercased().range(of:"@ibm.ca") != nil) || (emailString.lowercased().range(of:"@ca.ibm.com") != nil) ) {
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    private func setupView(){
        switch AppController.shared.appStatus {
        case .Unregisterd:
            showUregisteredView()
            
        case .ReceivedToken:
            showReadyForTokenView()
            
        case .ReadyForToken:
            showReadyForTokenView()
            
        default:
            showUregisteredView()
        }
    }
    
    private func showUregisteredView(){
        stackViewTopSpacing.constant = 6
        self.mainTextField.placeholder = "email"
        self.unregisteredView.isHidden = false
        self.sentTokenView.isHidden = true
        self.mainTextField.isSecureTextEntry = false
        self.enterEmailLabel.text = "Enter your email to request access token"
    }
    
    private func showReceivedTokenView(){
        stackViewTopSpacing.constant = 6
        self.unregisteredView.isHidden = true
        self.sentTokenView.isHidden = false
        self.enterEmailLabel.isHidden = true
        self.mainTextField.placeholder = "token"
        self.mainTextField.isSecureTextEntry = true
    }
    
    private func showReadyForTokenView(){
        stackViewTopSpacing.constant = 65.0
        self.unregisteredView.isHidden = true
        self.sentTokenView.isHidden = true
        self.enterEmailLabel.isHidden = false
        self.enterEmailLabel.text = "Please enter your access token"
        self.mainTextField.isSecureTextEntry = true
        self.mainTextField.placeholder = "token"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
