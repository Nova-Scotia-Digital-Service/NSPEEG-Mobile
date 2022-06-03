//
//  UIViewExtension.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-23.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    class func fromNib<T : UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
     func viewDesign(){
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
}
