//
//  ViewProfileCustomCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/10/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class ViewProfileCustomCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userFullName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.avatarImage.layer.cornerRadius = 27.5
        self.avatarImage.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
