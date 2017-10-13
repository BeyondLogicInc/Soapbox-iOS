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
    @IBOutlet weak var categoryUserCount: UILabel!    
    @IBOutlet weak var selectedCategoryImage: UIImageView!
    var delegate: categoryCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        self.categoryImageView.layer.cornerRadius = 5.0
        self.categoryImageView.layer.masksToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpCategoryTableViewCell.tapEdit(sender:)))
        addGestureRecognizer(tapGesture)
        
    }
    
    @objc func tapEdit(sender: UITapGestureRecognizer) {
        delegate?.categoryCellDelegate(self.tag, self)
    }
    
}

protocol categoryCellDelegate {
    func categoryCellDelegate(_ tag: Int, _ cell: SignUpCategoryTableViewCell)
}
