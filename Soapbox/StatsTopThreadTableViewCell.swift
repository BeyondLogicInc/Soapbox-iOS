//
//  StatsTopThreadTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/25/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class StatsTopThreadTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var upvoteCount: UILabel!
    @IBOutlet weak var viewsCount: UILabel!
    @IBOutlet weak var ratio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
