//
//  StatsTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/24/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class StatsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var upvoteCount: UILabel!
    @IBOutlet weak var title: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
