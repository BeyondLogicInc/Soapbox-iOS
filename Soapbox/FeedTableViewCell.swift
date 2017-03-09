//
//  FeedTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/6/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    weak var cellDelegate: FeedCellDelegate?
    
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
    
    @IBOutlet weak var threadOptionsBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        feedOwnerImage.layer.cornerRadius = 10.0
    }        
    @IBAction func toggleThreadOptions(_ sender: Any) {
        cellDelegate?.didPressButton(self.tag)
    }
}

protocol FeedCellDelegate: class {
    func didPressButton(_ tag: Int)
}
