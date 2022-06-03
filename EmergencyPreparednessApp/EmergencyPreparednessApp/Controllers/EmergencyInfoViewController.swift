//
//  EmergencyInfoViewController.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-18.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import WebKit
import QuartzCore

class EmergencyInfoViewController: BaseViewController, UIWebViewDelegate {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var headerView: UIView!{
        didSet{
            viewDesign(headerView)
        }
    }
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet weak var titleView: UIView!{ didSet{  viewDesign(titleView) }}
    @IBOutlet weak var viewSlide: UIView!{didSet{ setupViewGesture(viewSlide)}}
    
    @IBOutlet weak var sliderView: UISlider!
    
    @IBOutlet weak var swipeBtn: UIButton!{
        didSet{
            swipeBtn.isAccessibilityElement = true
            swipeBtn.accessibilityLabel = NSLocalizedString("Swipe right to call 911", comment: "")
        }
    }
    
    var viewTitle: String?
    var htmlFile: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupView()
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
        navigateBack()
    }
    
    private func setupView(){
        webView.delegate = self
        if let title = viewTitle, let htmlFile = htmlFile {
            titleLabel.text = title
            loadWebView(for: htmlFile, activityIndicator: activityIndicator, webView: webView)
        }
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
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        UIView.animate(withDuration: 0.5, animations: {
            self.sliderView.alpha = 1
        }, completion: { (finished: Bool) in
            UIView.animateKeyframes(withDuration: 0.5, delay: 1.0, options: [], animations: {
                self.sliderView.setValue(0, animated: true)
            })
        })

    }
    
    @objc override func swipeRight() {
       swipeViewAnimation(viewSlide, swipeBtn: swipeBtn)
    }
    
    deinit {
        print("EmergencyInfo Controller deallocated")
    }
    
 }
