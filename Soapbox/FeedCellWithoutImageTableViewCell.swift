//
//  FeedCellWithoutImageTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/29/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class FeedCellWithoutImageTableViewCell: UITableViewCell {

    weak var cellWithoutImageDelegate: FeedCellWithoutImageDelegate?
    
    @IBOutlet weak var threadCategory: UILabel!
    @IBOutlet weak var feedOwnerImage: UIImageView!
    @IBOutlet weak var threadOwnerName: UILabel!
    @IBOutlet weak var threadTimeLapsed: UILabel!
    @IBOutlet weak var threadOptionsBtn: UIButton!
    
    @IBOutlet weak var threadTitle: UILabel!
    @IBOutlet weak var threadDescription: UILabel!
    
    @IBOutlet weak var threadUpvotes: UILabel!
    @IBOutlet weak var threadReplies: UILabel!
    @IBOutlet weak var threadViews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        feedOwnerImage.layer.cornerRadius = 5.0
        feedOwnerImage.layer.masksToBounds = true
    }

    @IBAction func toggleThreadOptions(_ sender: Any) {
        cellWithoutImageDelegate?.didPressButtonWithoutImage(self.tag, self)
    }

}

protocol FeedCellWithoutImageDelegate: class {
    func didPressButtonWithoutImage(_ tag: Int, _ cell: FeedCellWithoutImageTableViewCell)
}
