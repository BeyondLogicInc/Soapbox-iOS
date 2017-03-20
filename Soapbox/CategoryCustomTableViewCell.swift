//
//  CategoryCustomTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/20/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class CategoryCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryThumbnail: UIImageView!
    
    @IBOutlet weak var categoryTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        categoryThumbnail.layer.cornerRadius = 5.0
        categoryThumbnail.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
