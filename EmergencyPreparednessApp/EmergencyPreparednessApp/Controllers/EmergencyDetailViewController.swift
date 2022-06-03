//
//  EmergencyDetailViewController.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-18.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class EmergencyDetailViewController: BaseViewController, UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var contentWebView: UIWebView!{
        didSet{
            contentWebView.backgroundColor = .clear
            contentWebView.isOpaque = false
        }
    }
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var headerView: UIView!{ didSet{ viewDesign(headerView) } }
    
    @IBOutlet weak var titleView: UIView!{ didSet{ viewDesign(titleView)} }
    
    @IBOutlet var dismissButton: UIButton!{
        didSet{
            dismissButton.backgroundColor = UIColor.init(hex: "0069B9")//UIColor.red
            dismissButton.layer.borderWidth = 1.0
            dismissButton.layer.borderColor = UIColor.darkGray.cgColor
            dismissButton.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet weak var listTableView: UITableView!{
        didSet{
            listTableView.separatorStyle = .none
            listTableView.estimatedRowHeight = 80
            listTableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    var dateText:String?
    var messageText:String?
    var getalertsList: [AlertMessage]?
    var setalertsList: [AlertMessage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        AppController.shared.loadAlertsList()
        getAlertsList()
        setupView()
        
    }
    
    private func getAlertsList(){
        if let alerts = AppController.shared.alertsList {
            getalertsList = alerts.reversed()
            guard let alertsList = getalertsList else {return}
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy hh:mm:ss" //Your date format
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
            
            alertsList.forEach { alert  in
                let date = dateFormatter.date(from: alert.receivedDate ?? "")
                let components = Calendar.current.dateComponents([.month, .day], from: date ?? Date(), to: Date())
                guard let dayDifference = components.day else {return}
                if dayDifference < 7 {
                    setalertsList.append(alert)
                }
            }
        }
    }
    
    private func setupView(){
        registerNib(nib: "AlertsViewCellTableViewCell", identifer: "AlertsCellId", listTableView: listTableView)
        contentWebView.delegate = self
        dateLabel.text = dateText
       
        if let messageText = messageText {
            showActivityIndicator(show: true, activityIndicator: activityIndicator)
            contentWebView.loadHTMLString("<html><style>p{font-family:\"Helvetica Neue\"; }</style><body><p>\(String(describing: messageText))</p></body></html>", baseURL: nil)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
       navigateBack()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        showActivityIndicator(show: false, activityIndicator: activityIndicator)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
       showActivityIndicator(show: false, activityIndicator: activityIndicator)
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        AppController.shared.deleteAlertItem()
        self.backButtonAction(self.backButton)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (setalertsList.count == 0){
            return 0
        }
        else{
            return (setalertsList.count)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlertsCellId", for: indexPath) as? AlertsViewCellTableViewCell
        cell?.selectionStyle = .none
                cell?.dateLabel.text = setalertsList[indexPath.row].receivedDate
                cell?.messageLabel.text = setalertsList[indexPath.row].content
        return cell!
    }
    
    deinit {
        print("EmergencyDetail Controller deallocated")
    }
}
