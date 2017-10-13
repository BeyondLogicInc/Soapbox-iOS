//
//  SearchPeopleTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/22/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class SearchPeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var about: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        avatarImage.layer.cornerRadius = 27.5
        avatarImage.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
