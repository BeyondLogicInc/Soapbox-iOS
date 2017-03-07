//
//  FeedViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/6/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import KeyClip

struct cellData {
    let name: String!
    let category: String!
    let time: String!
    let threadImage: UIImage!
    let title: String!
    let summary: String!
    let upvoteCnt: String!
    let repliesCnt: String!
    let viewsCnt: String!
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FeedCellDelegate {
        
    @IBOutlet weak var feedTableView: UITableView!
    var arrayOfCellData = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.separatorColor = UIColor.clear
        arrayOfCellData = [
            cellData(name: "Atharva Dandekar", category: "TV Shows", time: "50 mins ago", threadImage: #imageLiteral(resourceName: "hoc"), title: "House of cards season 4", summary: "That's a prevailing theme of the series' latest run, released Friday. When we left Kevin Spacey's President Underwood and his first lady Macbeth, Claire, (Robin Wright), he was locked in a tough re-election campaign and she, weary of being used for his political gain, was leaving him.", upvoteCnt: "35 Upvotes", repliesCnt: "8 Replies", viewsCnt: "105 Views"),
            cellData(name: "Mihir Karandikar", category: "Movies", time: "1 hour ago", threadImage: #imageLiteral(resourceName: "wallhaven300894"), title: "Interstellar", summary: "In the future, Earth is slowly becoming uninhabitable. Ex-NASA pilot Cooper, along with a team of researchers, is sent on a planet exploration mission to report which planet can sustain life.", upvoteCnt: "89 Upvotes", repliesCnt: "7 Replies", viewsCnt: "48 Views")
        ]
    }
    @IBAction func handleSignOut(_ sender: Any) {
        KeyClip.delete("soapbox.userdata")
        self.performSegue(withIdentifier: "toLoginViewSegue", sender: nil)
    }
    
    func updateWithSpacing(label: UILabel, lineSpacing: Float) {
        let attributedString = NSMutableAttributedString(string: label.text!)
        let mutableParagraphStyle = NSMutableParagraphStyle()
        mutableParagraphStyle.lineSpacing = CGFloat(lineSpacing)
        
        if let stringLength = label.text?.characters.count {
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: mutableParagraphStyle, range: NSMakeRange(0, stringLength))
        }
        label.attributedText = attributedString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        
        cell.cellDelegate = self
        cell.tag = indexPath.row
        
        cell.threadOwnerName.text = arrayOfCellData[indexPath.row].name
        cell.threadCategory.text = arrayOfCellData[indexPath.row].category
        cell.threadTimeLapsed.text = arrayOfCellData[indexPath.row].time
        cell.feedOwnerImage.image = #imageLiteral(resourceName: "bgart2")
        cell.threadImage.image = arrayOfCellData[indexPath.row].threadImage
        cell.threadTitle.text = arrayOfCellData[indexPath.row].title
//        let attrText = arrayOfCellData[indexPath.row].summary
        cell.threadDescription.text = arrayOfCellData[indexPath.row].summary
        cell.threadDescription.lineBreakMode = .byTruncatingTail
        updateWithSpacing(label: cell.threadDescription, lineSpacing: 2.5)
        cell.threadUpvotes.text = arrayOfCellData[indexPath.row].upvoteCnt
        cell.threadReplies.text = arrayOfCellData[indexPath.row].repliesCnt
        cell.threadViews.text = arrayOfCellData[indexPath.row].viewsCnt                
        cell.threadOptionsBtn.isHidden = false
        cell.contentView.backgroundColor = UIColor.init(colorLiteralRed: 234/255, green: 233/255, blue: 237/255, alpha: 1.0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func didPressButton(_ tag: Int) {
        print("I have pressed a button with a tag: \(tag)")
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let subview = alertController.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.backgroundColor = UIColor.white
        alertContentView.layer.cornerRadius = 15;
        
        let trackThreadActionImage = #imageLiteral(resourceName: "Binoculars")
        let readingListActionImage = #imageLiteral(resourceName: "Reading")
        let hideActionImage = #imageLiteral(resourceName: "Hide")
        let deleteActionImage = #imageLiteral(resourceName: "Delete")
        
        let trackThreadAction = UIAlertAction(title: "Track this thread", style: .default, handler: {
            (action) -> Void in
            print("Track button tapped")
        })
        
        trackThreadAction.setValue(trackThreadActionImage, forKey: "image")
        
        let readingListAction = UIAlertAction(title: "Add to reading list", style: .default, handler: {
            (action) -> Void in
            print("reading list button tapped")
        })
        readingListAction.setValue(readingListActionImage, forKey: "image")
        
        let hideThreadAction = UIAlertAction(title: "Hide this thread", style: .default, handler: {
            (action) -> Void in
            print("hide thread button tapped")
        })
        hideThreadAction.setValue(hideActionImage, forKey: "image")
        
        let deleteThreadAction = UIAlertAction(title: "Delete this thread", style: .destructive, handler: {
            (action) -> Void in
            print("Track button tapped")
        })
        deleteThreadAction.setValue(deleteActionImage, forKey: "image")
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel,
            handler: {
            (action) -> Void in
            print("cancel")
        })
        
        alertController.addAction(trackThreadAction)
        alertController.addAction(readingListAction)
        alertController.addAction(hideThreadAction)
        alertController.addAction(deleteThreadAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
