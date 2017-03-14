//
//  FeedViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/6/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import KeyClip
import SDWebImage
import XLActionController

struct cellData {
    let name: String!
    let category: String!
    let time: String!
    let threadImage: String!
    let title: String!
    let summary: String!
    let upvoteCnt: String!
    let repliesCnt: String!
    let viewsCnt: String!
    let avatarpath: String!
    let userid: Int!
    let threadno: String!
    let tracked: Bool!
    let isRead: Bool!
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FeedCellDelegate {
        
    @IBOutlet weak var feedTableView: UITableView!
    
    let loader = UIActivityIndicatorView()
    
    var arrayOfThreadImages: [UIImage] = []
    var arrayOfCellData = [cellData]()
    var userinfoArr = [String]()
    let api = Api()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.separatorColor = UIColor.clear
        
        //Initialize loader
        loader.frame = CGRect(x: 0, y: -65.0, width: self.view.frame.width, height: self.view.frame.height)
        loader.isHidden = false
        loader.hidesWhenStopped = true
        loader.backgroundColor = UIColor.white
        loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.loader.startAnimating()
        
        userinfoArr = api.getUserInfoFromKeychain()
        
        populateFeed()
    }
    
    func populateFeed() {
        let request = api.populateThreads()
        request.validate()
        request.responseJSON { response in
            if response.error != nil {
                
            }
            else {
                if let jsonValue = response.result.value {
                    let results = JSON(jsonValue)["results"]
                    if results.count > 0 {
                        for item in results.arrayValue {
                            self.arrayOfCellData.append(
                                cellData(
                                    name: item["fname"].stringValue + " " + item["lname"].stringValue,
                                    category: item["cname"].stringValue,
                                    time: item["timestamp"].stringValue,
                                    threadImage: item["imagepath"].stringValue,
                                    title: item["title"].stringValue,
                                    summary: item["description"].stringValue,
                                    upvoteCnt: item["upvotes"].stringValue,
                                    repliesCnt: item["replies"].stringValue,
                                    viewsCnt: item["views"].stringValue,
                                    avatarpath: item["avatarpath"].stringValue,
                                    userid: item["uid"].intValue,
                                    threadno: item["srno"].stringValue,
                                    tracked: item["track"].boolValue,
                                    isRead: item["reading"].boolValue
                                )
                            )
                            if item["imagepath"].stringValue != ""{
                                let url = URL(string: self.api.BASE_URL + item["imagepath"].stringValue)
                                let data = try? Data(contentsOf: url!)
                                self.arrayOfThreadImages.append(self.resizeImage(image: UIImage(data: data!)!))
                            }
                            else {
                                self.arrayOfThreadImages.append(self.resizeImage(image: #imageLiteral(resourceName: "default-cover")))
                            }
                        }
                        self.loader.stopAnimating()
                        self.feedTableView.reloadData()
                        return
                    }
                }
            }
        }
    }
    
    @IBAction func handleSignOut(_ sender: Any) {
        let request = api.logout()
        request.validate()
        request.responseJSON {response in
            if (response.error != nil) {
                let error: String = (response.error?.localizedDescription)!
                print(error)
            }
            else {
                if let jsonValue = response.result.value {
                    let results = JSON(jsonValue)
                    if results["response"].boolValue {
                        KeyClip.delete("soapbox.userdata")
                        self.api.deleteImage()
                        self.performSegue(withIdentifier: "toLoginViewSegue", sender: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func fromCreateNewThreadView(segue: UIStoryboardSegue) {
        
    }
    
    func resizeImage(image:UIImage) -> UIImage
    {
        var actualHeight:Float = Float(image.size.height)
        var actualWidth:Float = Float(image.size.width)
        
        let maxHeight:Float = 147.0 //your choose height
        let maxWidth:Float = Float(self.view.frame.width)  //your choose width
        
        var imgRatio:Float = actualWidth/actualHeight
        let maxRatio:Float = maxWidth/maxHeight
        
        if (actualHeight > maxHeight) || (actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio)
            {
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else
            {
                actualHeight = maxHeight;
                actualWidth = maxWidth;
            }
        }
        
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth) , height: CGFloat(actualHeight) )
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        
        let img:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        let imageData:NSData = UIImageJPEGRepresentation(img, 1.0)! as NSData
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData as Data)!
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
        
        cell.feedOwnerImage.sd_setImage(with: URL(string: api.BASE_URL + arrayOfCellData[indexPath.row].avatarpath), placeholderImage: #imageLiteral(resourceName: "avatar_male"))        
        DispatchQueue.main.async {
            cell.threadImage.image = self.arrayOfThreadImages[indexPath.row]
        }
        cell.threadTitle.text = arrayOfCellData[indexPath.row].title
        cell.threadDescription.text = (arrayOfCellData[indexPath.row].summary).html2String
        cell.threadDescription.lineBreakMode = .byTruncatingTail
        cell.threadUpvotes.text = arrayOfCellData[indexPath.row].upvoteCnt + " Upvotes"
        cell.threadReplies.text = arrayOfCellData[indexPath.row].repliesCnt + " Replies"
        cell.threadViews.text = arrayOfCellData[indexPath.row].viewsCnt + " Views"
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
        let actionController = YoutubeActionController()
        
        var trackMsg = "Track this thread"
        if arrayOfCellData[tag].tracked as Bool {
            trackMsg = "Tracking"
            actionController.addAction(Action(ActionData(title: trackMsg, image: UIImage(named: "Binoculars_Filled")!), style: .default, handler: { action in
                print("Pressed already tracked")
            }))
        } else {
            actionController.addAction(Action(ActionData(title: trackMsg, image: UIImage(named: "Binoculars")!), style: .default, handler: { action in
                print("Pressed tracking")
            }))
        }
        
        
        var readMsg: String = "Add to reading list"
        if arrayOfCellData[tag].tracked as Bool {
            readMsg = "Added to reading list"
            actionController.addAction(Action(ActionData(title: readMsg, image: UIImage(named: "Reading_Filled")!), style: .default, handler: { action in
                print("Added to reading list")
            }))
        } else {
            actionController.addAction(Action(ActionData(title: readMsg, image: UIImage(named: "Reading")!), style: .default, handler: { action in
                print("add to reading list")
            }))
        }
        
        actionController.addAction(Action(ActionData(title: "Hide this thread", image: UIImage(named: "Hide")!), style: .default, handler: { action in
            print("Pressed hide this thred")
        }))
        
        if arrayOfCellData[tag].userid as Int == Int(userinfoArr[0]) {
            actionController.addAction(Action(ActionData(title: "Delete this thread", image: UIImage(named: "Delete_Colored")!), style: .destructive, handler: { action in
                print("Pressed delete this thread")
            }))
        }
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "Cancel")!), style: .cancel, handler: { action in
            print("Pressed cancel")
        }))
        
        self.present(actionController, animated: true, completion: nil)
    }
    
}
