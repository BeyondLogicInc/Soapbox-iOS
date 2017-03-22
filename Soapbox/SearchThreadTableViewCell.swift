//
//  SearchThreadTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/22/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class SearchThreadTableViewCell: UITableViewCell {

    @IBOutlet weak var feedOwnerImage: UIImageView!
    @IBOutlet weak var feedOwnerName: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var timeElapsed: UILabel!
    @IBOutlet weak var threadTitle: UILabel!
    @IBOutlet weak var threadDescription: UILabel!
    @IBOutlet weak var upvotes: UILabel!
    @IBOutlet weak var replies: UILabel!
    @IBOutlet weak var views: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        feedOwnerImage.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
