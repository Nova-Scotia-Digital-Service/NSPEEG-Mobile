//
//  TermsAndConditionsViewController.swift
//  EmergencyPreparednessApp
//
//  Created by Parlad Dhungana on 2018-12-07.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

class TermsAndConditionsViewController: BaseViewController,  UIWebViewDelegate {
    
    //MARK: - IBOutlet
    private let fileName = "termsAndConditions1"
    
    @IBOutlet weak var containerView: UIView!{ didSet {containerView.viewDesign() } }
    @IBOutlet weak var acceptButton: UIButton!{ didSet {acceptButton.viewDesign() } }
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        loadWebView(for: fileName, activityIndicator: activityIndicator, webView: webView)
    }
    
    @IBAction func acceptButtonClicked(_ sender: Any) {

        UserDefaults.standard.set(Constants.AcceptedTermsAndConditions, forKey: "TermsAndConditions")
        self.dismiss(animated: true, completion: nil)
        AppController.shared.loadLoginPage()
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool{
        return shouldLoadRequest(with: navigationType, request: request)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        showActivityIndicator(show: false, activityIndicator: activityIndicator)
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        showActivityIndicator(show: false, activityIndicator: activityIndicator)
    }
    
    
    deinit {
        print("Terms and conditons deallocated")
    }
}
