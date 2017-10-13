//
//  CategoryCustomTableViewCell.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/20/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class CategoryCustomTableViewCell: UITableViewCell {

    weak var cellDelegate: CustomCategoryCellDelegate?
    
    @IBOutlet weak var categoryThumbnail: UIImageView!
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var threadCountLabel: UILabel!
    @IBOutlet weak var userCountLabel: UILabel!
    
    @IBOutlet weak var categoryFollowButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layoutIfNeeded()
        categoryThumbnail.layer.cornerRadius = 5.0
        categoryThumbnail.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func toggleCategoryFollow(_ sender: Any) {
        cellDelegate?.didPressButton(self.tag, self)
    }
    
}

protocol CustomCategoryCellDelegate: class {
    func didPressButton(_ tag: Int, _ cell: CategoryCustomTableViewCell)
}
