//
//  ThreatsViewController.swift
//  EmergencyPreparednessApp
//
//  Created by Janice Lobo on 2018-06-22.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit


struct Popup {
    var image: UIImage?
    var title: String?
    var description: String?
}

class ThreatsViewController: BaseViewController {
    
    @IBOutlet weak var swipeBtn: UIButton!
    @IBOutlet weak var swipeView: UIView!{ didSet{ setupViewGesture(swipeView)} }
    
    @IBOutlet weak var titleView: UIView!{ didSet{ viewDesign(titleView)} }

    @IBOutlet weak var headerView: UIView!{ didSet{viewDesign(headerView)} }

    private let navTitles = [Constants.fireTitle, Constants.powerTitle, Constants.workplaceTitle, Constants.medicalTitle,
        Constants.odoursTitle, Constants.vehicleCollisionTitle, Constants.bombTitle, Constants.civilTitle, Constants.mentalhealth
    ]
    
    private let fileNames = ["fire","powerloss", "workplace_violence", "medical" ,"odours", "collision", "bombThreats", "civil","mentalhealth"]
    
    //MARK: - IBOutlet Actions
    
    @IBAction func showPopups(_ sender: UIButton) {
        
        let tag = sender.tag
        switch tag {
        case 0:
            showPopup(sender)
        case 1:
            showPopup(sender)
        case 2:
             showPopup(sender)
        default:
            return
        }
    }
    
    @IBAction func performSegueWithButtonTag(_ sender: UIButton) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: "EmergencyInfoViewController") as! EmergencyInfoViewController
        let tag = sender.tag
        
        switch tag {
        case 0:
            setupAndPushViewController(tag, navTitles: navTitles, fileNames: fileNames, vc: viewController)
        case 1:
            setupAndPushViewController(tag, navTitles: navTitles, fileNames: fileNames, vc: viewController)
        case 2:
            setupAndPushViewController(tag, navTitles: navTitles, fileNames: fileNames, vc: viewController)
        case 3:
            setupAndPushViewController(tag, navTitles: navTitles, fileNames: fileNames, vc: viewController)
        case 4:
            setupAndPushViewController(tag, navTitles: navTitles, fileNames: fileNames, vc: viewController)
        case 5:
            setupAndPushViewController(tag, navTitles: navTitles, fileNames: fileNames, vc: viewController)
        case 6:
            setupAndPushViewController(tag, navTitles: navTitles, fileNames: fileNames, vc: viewController)
        case 7:
            setupAndPushViewController(tag, navTitles: navTitles, fileNames: fileNames, vc: viewController)
        case 8:
            setupAndPushViewController(tag, navTitles: navTitles, fileNames: fileNames, vc: viewController)
        default:
            return
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: Any) {
       navigateBack()
    }
    
    //MARK: - Helper functions
    private func showPopup(_ sender: UIButton){
        let viewController = storyboard?.instantiateViewController(withIdentifier: "popupViewController") as! PopViewController
        let image = sender.currentImage
        let title = sender.currentTitle
        let description = Constants.popupMessages[sender.tag]
        let popup = Popup(image: image, title: title, description: description)
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame =  view.frame
        viewController.didMove(toParent: self)
        viewController.popup = popup
    }
    
    @objc override func swipeRight() {
        swipeViewAnimation(swipeView, swipeBtn: swipeBtn)
    }
    
    
    deinit {
        print("Threats controller is deallocated")
    }
}
