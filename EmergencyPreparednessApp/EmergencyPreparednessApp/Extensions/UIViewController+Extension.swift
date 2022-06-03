//
//  UIViewController+Extension.swift
//  EmergencyPreparednessApp
//
//  Created by Steven Dai on 2019-02-07.
//  Copyright © 2019 IBM. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
