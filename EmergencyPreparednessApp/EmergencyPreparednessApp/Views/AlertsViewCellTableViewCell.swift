//
//  AlertsViewCellTableViewCell.swift
//  EmergencyPreparednessApp
//
//  Created by Janice Lobo on 2018-06-28.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

class AlertsViewCellTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var cellContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        cellContentView.layer.borderColor = UIColor.lightGray.cgColor
        cellContentView.layer.borderWidth = 1.0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
