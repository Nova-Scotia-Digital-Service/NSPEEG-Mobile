//
//  ListTableViewCell.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-18.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import QuartzCore

class ListTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var outlineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.formatCell()
    }
    
    public func formatCell(){
        outlineView.layer.borderColor = UIColor.darkGray.cgColor
        outlineView.layer.borderWidth = 1.0
        outlineView.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
