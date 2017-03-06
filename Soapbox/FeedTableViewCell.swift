//
//  FeedTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/6/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var threadOwnerName: UILabel!
    @IBOutlet weak var threadCategory: UILabel!
    @IBOutlet weak var threadTimeLapsed: UILabel!
    @IBOutlet weak var feedOwnerImage: UIImageView!
    
    @IBOutlet weak var threadImage: UIImageView!
    @IBOutlet weak var threadTitle: UILabel!
    @IBOutlet weak var threadDescription: UILabel!
    
    @IBOutlet weak var threadUpvotes: UILabel!
    @IBOutlet weak var threadReplies: UILabel!
    @IBOutlet weak var threadViews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }    
}
