//
//  ReadingListTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/18/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class ReadingListTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var threadTitle: UILabel!
    @IBOutlet weak var timeElapsedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.avatarImageView.layer.cornerRadius = 27.5
        self.avatarImageView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
