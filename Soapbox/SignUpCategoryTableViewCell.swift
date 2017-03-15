//
//  SignUpCategoryTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/15/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class SignUpCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryThreadCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.categoryImageView.layer.cornerRadius = 5.0
        self.categoryImageView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
