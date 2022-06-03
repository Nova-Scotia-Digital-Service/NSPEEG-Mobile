//
//  LoginViewController+AppAuth.swift
//  EmergencyPreparednessApp
//
//  Created by John Martino on 2019-02-28.
//  Copyright © 2019 IBM. All rights reserved.
//

import UIKit
import AppAuth

let kIssuer = "https://mynsid.novascotia.ca/auth/oidc/public"
let kClientID = "https://novascotia.sharepoint.com/sites/ISD/SitePages/Corporate%20Security-Emergency%20Preparedeness.aspx?web=1"
let kRedirectURI = AuthenticationType.login.rawValue
let userInfoURI = "https://mynsid.novascotia.ca/auth/oidc/userinfo"

extension LoginViewController
{
    func authWithAutoCodeExchange()
    {
        if let issuer = URL(string: kIssuer)
        {
            OIDAuthorizationService.discoverConfiguration(forIssuer: issuer) { configuration, error in
                guard let config = configuration else { print(error?.localizedDescription ?? "issuer not found"); return }
                self.doAuthWithAutoCodeExchange(configuration: config, clientID: kClientID, clientSecret: nil)
            }
        }
    }
    
    func doAuthWithAutoCodeExchange(configuration: OIDServiceConfiguration, clientID: String, clientSecret: String?)
    {
        guard let redirectURI = URL(string: kRedirectURI) else {
            print("Error creating URL for : \(kRedirectURI)")
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("Error accessing AppDelegate")
            return
        }
        
        // builds authentication request
        let request = OIDAuthorizationRequest(configuration: configuration,
                                              clientId: clientID,
                                              clientSecret: clientSecret,
                                              scopes: [OIDScopeOpenID, OIDScopeProfile],
                                              redirectURL: redirectURI,
                                              responseType: OIDResponseTypeCode,
                                              additionalParameters: nil)
        
        // performs authentication request
        print("Initiating authorization request with scope: \(request.scope ?? "DEFAULT_SCOPE")")
        
        appDelegate.currentAuthorizationFlow = OIDAuthState.authState(byPresenting: request, presenting: self) { authState, error in
            if let error = error { AuthenticationType.login.loginFailed(error: error); return }
            guard let authState = authState else {
                let error = NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey : "Invalid Authentication State."])
                AuthenticationType.login.loginFailed(error: error)
                return
            }
            self.process(authState: authState)
        }
    }
    
    private func process(authState: OIDAuthState)
    {
        guard let userInfoEndpoint = authState.lastTokenResponse?.request.configuration.discoveryDocument?.userinfoEndpoint else {
            AuthenticationType.login.loginFailed(error: NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey : "Userinfo endpoint not declared in discovery document"]))
            return
        }
        
        authState.performAction { accessToken, idToken, error in
            if let error = error
            {
                print("Error fetching tokens: " + error.localizedDescription)
                AuthenticationType.login.loginFailed(error: error)
                return
            }
            
            // creates request to the userinfo endpoint, with access token in the Authorization header
            var request = URLRequest(url: userInfoEndpoint)
            let authorizationHeaderValue = String(format: "Bearer %@", accessToken ?? "")
            request.addValue(authorizationHeaderValue, forHTTPHeaderField: "Authorization")
            let session = URLSession(configuration: URLSessionConfiguration.default)

            // performs HTTP request
            let postDataTask = session.dataTask(with: request) { data, response, error in
                if let error = error
                {
                    print("HTTP request failed: " + error.localizedDescription)
                    AuthenticationType.login.loginFailed(error: error)
                    return
                }
                
                guard
                    let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any],
                    let source = json?["AuthenticationSource"] as? String
                else
                {
                    AuthenticationType.login.loginFailed(error: NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey : "The authentication source was not found."]))
                    return
                }
                
                AuthenticationType.login.handleAuthentication(token: authState.lastTokenResponse?.accessToken, authService: source)
            }
            postDataTask.resume()
        }
    }
}
