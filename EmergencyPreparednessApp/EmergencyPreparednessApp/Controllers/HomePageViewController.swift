//
//  HomePageViewController.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-16.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import QuartzCore

class HomePageViewController: BaseViewController, CallSliderDelegate, UITableViewDelegate, UITableViewDataSource, AlertViewCellTableViewCellDelegate {
    
    @IBOutlet var headerView: UIView!{ didSet{ viewDesign(headerView)} }
    
    @IBOutlet var listTableView: UITableView!

    @IBOutlet weak var swipeBtn: UIButton!{
        didSet{
            swipeBtn.isAccessibilityElement = true
            swipeBtn.accessibilityLabel = NSLocalizedString("Swipe right to call 911", comment: "")
        }
    }
    
    @IBOutlet weak var swipeView: UIView!{ didSet{ setupViewGesture(swipeView)} }

    var selectedWarning: AlertMessage?
    
    private let navTitles = [Constants.whenToCallTitle,
         Constants.socialMediaTitle,
         Constants.emergencyTitle,
         Constants.roadsWeatherTitle,
         Constants.reportCrimeTitle,
         Constants.usingAppTitle,
         Constants.termsAndConditions]
    
    private let fileNames = ["whentocall", "socialmedia","emergencynumbers","roads_weather","security", "usingtheapp","termsAndConditions2"]
        
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewController()
    }
    
    private func setupViewController(){
        
        NotificationCenter.default.addObserver(self,
        selector: #selector(receivedPushNotification),
        name: NSNotification.Name(rawValue: Constants.pushNotificationReceived), object: nil)
        
        //registering all custome nibs
        registerNib(nib: "ListTableViewCell", identifer: "ListCellId", listTableView: listTableView)
        registerNib(nib: "AlertViewCellTableViewCell", identifer: "AlertCellId", listTableView: listTableView)
        registerNib(nib: "CallEmergencyTableViewCell", identifer: "EmergencyCellId", listTableView: listTableView)
        registerNib(nib: "SpacerViewCell", identifer: "SpacerId", listTableView: listTableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.listTableView.reloadData()
    }
    
    
    @objc func receivedPushNotification(notification:Notification) -> Void{
        self.listTableView.reloadData()
    }
    
    
    func didMakeCall(sender: CallSlider){
        AppController.shared.makePhoneCall(phoneNumber: "911")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var count = 0
        if section == 0{
            if AppController.shared.alertWarning != nil {
                count = 1
            }
            return count
        }else if section == 1{
            count = 1
        }
        return count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var cell: UITableViewCell?
        
        if indexPath.section == 0{
            cell = tableView.dequeueReusableCell(withIdentifier: "AlertCellId", for: indexPath) as? AlertViewCellTableViewCell
            cell?.selectionStyle = .none
            (cell as? AlertViewCellTableViewCell)?.delegate = self
            
            if let alertItem = AppController.shared.alertWarning{
                (cell as? AlertViewCellTableViewCell)?.dateLabel.text = alertItem.receivedDate
                (cell as? AlertViewCellTableViewCell)?.messageLabel.text = alertItem.content
                (cell as? AlertViewCellTableViewCell)?.currentIndexPath = indexPath
            }
        }else if indexPath.section == 1{
        
            cell = tableView.dequeueReusableCell(withIdentifier: "ListCellId", for: indexPath) as? ListTableViewCell
        }
        
        return cell!
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return 2
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0{
            return 85.0
        }
        else{
            return 0.0
        }
    }

    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let selectedRow = indexPath.row
            selectedWarning = AppController.shared.alertsList?[selectedRow]
            self.performSegue(withIdentifier: "WarningDetailId", sender: self)
        }
    }
    
    func didClose(sender: AlertViewCellTableViewCell){
        print("Close \(sender.currentIndexPath.row) in section \(sender.currentIndexPath.section)")
        AppController.shared.deleteAlertItem()
        self.listTableView.reloadSections(IndexSet(integersIn: 0..<1), with: UITableView.RowAnimation.automatic)
    }
    
    
    @IBAction func performSeguesWithButtonTag(_ sender: UIButton) {

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
            self.performSegue(withIdentifier: "EmergencyThreatsId", sender: self)
        case 8:
            self.performSegue(withIdentifier: "WarningDetailId", sender: self)
        default:
            return
        }
        
    }
   
    
    //MARK: - Helper Functions
    
    @objc override func swipeRight() {
        swipeViewAnimation(swipeView, swipeBtn: swipeBtn)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        print("Notification removed")
    }
   
}

