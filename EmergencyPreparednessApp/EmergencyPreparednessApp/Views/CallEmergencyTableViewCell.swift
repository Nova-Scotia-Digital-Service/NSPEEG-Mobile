//
//  CallEmergencyTableViewCell.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-24.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

class CallEmergencyTableViewCell: UITableViewCell {

    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var outllineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        outllineView.layer.borderColor = UIColor.darkGray.cgColor
        outllineView.layer.borderWidth = 1.0
        outllineView.layer.cornerRadius = 5.0
        outllineView.backgroundColor = UIColor.red
        titleLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
