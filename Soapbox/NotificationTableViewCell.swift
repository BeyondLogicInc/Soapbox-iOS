//
//  NotificationTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/29/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var notificationContent: UILabel!
    
    @IBOutlet weak var timestamp: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        avatarImage.layer.cornerRadius = 5.0
        avatarImage.layer.masksToBounds = true
        }
    
}
