//
//  BaseViewController.swift
//  EmergencyPreparednessApp
//
//  Created by Parlad Dhungana on 2018-12-07.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    public func navigateBack(){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }

    public func setupAndPushViewController(_ tag: Int, navTitles: [String], fileNames: [String], vc: EmergencyInfoViewController){
        vc.viewTitle = navTitles[tag]
        vc.htmlFile = fileNames[tag]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func viewDesign(_ view: UIView){
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    public func registerNib(nib name: String, identifer: String, listTableView: UITableView){
        let nib = UINib(nibName: name, bundle: nil)
        listTableView.register(nib, forCellReuseIdentifier: identifer)
    }
    
    public func setupViewGesture(_ view: UIView){
        view.isAccessibilityElement = true
        view.accessibilityLabel = NSLocalizedString("Swipe right to call 911", comment: "")
        let right = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
        right.direction = .right
        view.addGestureRecognizer(right)
    }
    
    @objc func swipeRight(){}
    
    public func swipeViewAnimation(_ swipeView: UIView, swipeBtn: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            swipeView.alpha = 1
            swipeView.frame.origin.x += (swipeBtn.frame.width - swipeView.frame.width)
            AppController.shared.makePhoneCall(phoneNumber: "911")
            
        }){ finished in
            if finished {
                UIView.animateKeyframes(withDuration: 0.5, delay: 1.0, options: [], animations: {
        
                    swipeView.frame.origin.x -= (swipeBtn.frame.width - swipeView.frame.width)
                })
            }
        }
    }
    
    public func showActivityIndicator(show: Bool, activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async {
            activityIndicator.isHidden = !show
            if show{
                activityIndicator.startAnimating()
            }else{
               activityIndicator.stopAnimating()
            }
        }
    }
    
    public func loadWebView(for url: String, activityIndicator: UIActivityIndicatorView, webView: UIWebView){
        guard let url = Bundle.main.url(forResource: url, withExtension: "html") else {return}
        let request = URLRequest(url: url)
        showActivityIndicator(show: true, activityIndicator: activityIndicator)
        webView.loadRequest(request)
    }
    
    
    public func shouldLoadRequest(with navigationType: UIWebView.NavigationType, request: URLRequest) -> Bool{
        
        var returnValue = true
        guard let url = request.url else {return false}
        switch navigationType {
        case .linkClicked:
            checkIfUrlCanBeOpened(url)
            returnValue = false
        case .other:
            checkIfUrlCanBeOpened(url)
            returnValue = true
        default:
            returnValue = true
        }
        return returnValue
    }
    
    public func checkIfUrlCanBeOpened(_ url: URL){
        if UIApplication.shared.canOpenURL(url){
           UIApplication.shared.open(url, options: [:])
        }
    }
  
}
