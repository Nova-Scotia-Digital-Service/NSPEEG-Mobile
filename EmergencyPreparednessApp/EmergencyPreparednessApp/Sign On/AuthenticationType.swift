//
//  AuthenticationType.swift
//  EmergencyPreparednessApp
//
//  Created by John Martino on 2019-02-11.
//  Copyright © 2019 IBM. All rights reserved.
//

import UIKit

let allowableServices = ["tests.novascotia.ca", "sts.novascotia.ca"]
// to be added at a later date: "ststest.nshealth.ca", "sts.nshealth.ca"

enum AuthenticationType: String
{
    case login = "servicenovascotiaauth://authenticate"
    case logoff = "servicenovascotialogout://logout"
    
    func handleAuthentication(token: String? = nil, authService: String? = nil)
    {
        switch self
        {
        case .login:
            guard let token = token, let authService = authService else { loginFailed(error: nil); return }
            allowableServices.contains(authService) ? loginSucceeded(token: token) : loginFailed(error: NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "The service, " + authService + ", is not authorized for this application."]))
            
        case .logoff: reset()
        }
    }
    
    private func loginSucceeded(token: String)
    {
        DispatchQueue.main.async {
            _ = KeychainManager.shared.add(token: token)
            NotificationCenter.default.post(name: loginSuccessfulNotificationName, object: nil)
        }
    }
    
    func loginFailed(error: Error?)
    {
        DispatchQueue.main.async {
            let errorMessage = error?.localizedDescription ?? "Incorrect Login Credentials"
            let alert = UIAlertController(title: "Login", message: errorMessage, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel) { alert in }
            alert.addAction(ok)
            let window = UIApplication.shared.delegate?.window
            window??.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func reset()
    {
        KeychainManager.shared.removeToken()
    }
}
