//
//  AlertViewCellTableViewCell.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-24.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit
import QuartzCore

protocol AlertViewCellTableViewCellDelegate: class {
    func didClose(sender: AlertViewCellTableViewCell)
}

class AlertViewCellTableViewCell: UITableViewCell {

    weak var delegate: AlertViewCellTableViewCellDelegate?
    
    var currentIndexPath = IndexPath()
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.layer.borderWidth = 1.0
//        self.contentView.layer.borderColor = UIColor.darkGray.cgColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        if let delegate = delegate{
            delegate.didClose(sender: self)
        }
    }
}
