//
//  EmergencyGuideViewController.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-18.
//  Copyright © 2017 Jubin Jose. All rights reserved.
//

import UIKit
import QuartzCore

class EmergencyGuideViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet var dial911Button: UIButton!{
        didSet{
            dial911Button.backgroundColor = UIColor.red
            dial911Button.layer.borderWidth = 1.0
            dial911Button.layer.borderColor = UIColor.darkGray.cgColor
            dial911Button.layer.cornerRadius = 5.0
        }
    }
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var headerTitleLabel: UILabel!
    
    @IBOutlet var headerView: UIView!{ didSet{viewDesign(headerView)} }
    
    @IBOutlet var webView: UIWebView!{
        didSet{
            webView.backgroundColor = .clear
            webView.isOpaque = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        loadWebView(for: "911", activityIndicator: activityIndicator, webView: webView)
        // Do any additional setup after loading the view.
    }

    @IBAction func backButtonAction(_ sender: Any) {
        navigateBack()
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool{
        return shouldLoadRequest(with: navigationType, request: request)
    }
    
    @IBAction func dial911Tapped(_ sender: Any) {
        AppController.shared.makePhoneCall(phoneNumber: "911")
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
      showActivityIndicator(show: false, activityIndicator: activityIndicator)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        showActivityIndicator(show: false, activityIndicator: activityIndicator)
    }
    
    
    deinit {
        print("EmergencyGuide Controller deallocated")
    }
}

// Helper function inserted by Swift 4.2 migrator.
