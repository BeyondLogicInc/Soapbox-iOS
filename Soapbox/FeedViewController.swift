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
import PKHUD

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
    var tracked: Bool!
    var isRead: Bool!
}

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FeedCellDelegate, FeedCellWithoutImageDelegate {
        
    @IBOutlet weak var feedTableView: UITableView!
    
    @IBOutlet weak var leftBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    let loader = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    let noDataView = UIView()
    
    var arrayOfThreadImages: [UIImage] = []
    var arrayOfCellData = [cellData]()
    var userinfoArr = [String]()
    let api = Api()
    
    var tagName: String = ""
    var categoryId: Int = 0
    var categoryName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedTableView.separatorColor = UIColor.clear
        feedTableView.refreshControl = refreshControl
        
        self.navigationItem.hidesBackButton = true
        
        refreshControl.addTarget(self, action: #selector(FeedViewController.pullToRefresh), for: .valueChanged)
        
        HUD.dimsBackground = false
        HUD.allowsInteraction = false
        
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
        
        if tagName == "" && categoryId == 0 {
            populateFeed(tag: "", categoryId: 0)
            self.navigationItem.title = "SOAPBOX"
            rightBarButtonItem.isEnabled = true
        } else {
            if tagName != "" {
                populateFeed(tag: tagName, categoryId: 0)
                self.navigationItem.title = "#\(tagName)"
            } else if categoryId != 0 {
                populateFeed(tag: "", categoryId: categoryId)
                self.navigationItem.title = "\(categoryName)"
            }
            rightBarButtonItem.isEnabled = false
            let btn = UIBarButtonItem()
            btn.title = "Back"
            btn.target = self
            btn.action = #selector(backBtnTapped)
            self.navigationItem.leftBarButtonItem = btn
        }
    }
    
    func backBtnTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadNoDataView() {
        noDataView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        noDataView.backgroundColor = #colorLiteral(red: 0.9342361093, green: 0.9314675331, blue: 0.9436802864, alpha: 1)
        let noDataLabel = UILabel()
        if tagName == "" && categoryId == 0 {
            noDataLabel.text = "Couldn't find anything"
        } else if tagName != "" {
            noDataLabel.text = "Couldn't find anything related to #\(tagName)"
        } else if categoryId != 0 {
            noDataLabel.text = "Couldn't find anything related to \(categoryName)"
        }
        noDataLabel.frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 20)
        noDataLabel.font = UIFont(name: "OpenSans", size: 15.0)!
        noDataLabel.textAlignment = NSTextAlignment.center
        noDataView.addSubview(noDataLabel)
        self.view.addSubview(noDataView)
    }
    
    func populateFeed(tag: String, categoryId: Int) {
        let request = api.populateThreads(tag: tag, categoryId: categoryId)
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
                    } else {
                        self.loader.stopAnimating()
                        self.loadNoDataView()
                    }
                }
            }
        }
    }
    
    func pullToRefresh() {
        arrayOfCellData.removeAll()
        if tagName == "" && categoryId == 0 {
            populateFeed(tag: "", categoryId: 0)
        } else {
            if tagName != "" {
                populateFeed(tag: tagName, categoryId: 0)
            } else if categoryId != 0 {
                populateFeed(tag: "", categoryId: categoryId)
            }
        }
        refreshControl.endRefreshing()
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
        
        if arrayOfCellData[indexPath.row].threadImage == "" {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "feedCellWithoutImage", for: indexPath) as! FeedCellWithoutImageTableViewCell
            cell.cellWithoutImageDelegate = self
            cell.tag = indexPath.row
            cell.threadOwnerName.text = arrayOfCellData[indexPath.row].name
            cell.threadCategory.text = arrayOfCellData[indexPath.row].category
            cell.threadTimeLapsed.text = arrayOfCellData[indexPath.row].time
            cell.feedOwnerImage.sd_setImage(with: URL(string: api.BASE_URL + arrayOfCellData[indexPath.row].avatarpath), placeholderImage: #imageLiteral(resourceName: "avatar_male"))
            cell.threadTitle.text = arrayOfCellData[indexPath.row].title
            cell.threadDescription.text = (arrayOfCellData[indexPath.row].summary).html2String
            cell.threadDescription.lineBreakMode = .byTruncatingTail
            cell.threadUpvotes.text = arrayOfCellData[indexPath.row].upvoteCnt + " Upvotes"
            cell.threadReplies.text = arrayOfCellData[indexPath.row].repliesCnt + " Replies"
            cell.threadViews.text = arrayOfCellData[indexPath.row].viewsCnt + " Views"
            cell.threadOptionsBtn.isHidden = false
            cell.contentView.backgroundColor = UIColor.init(colorLiteralRed: 234/255, green: 233/255, blue: 237/255, alpha: 1.0)
            
            return cell
            
        } else {
            
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
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfCellData[indexPath.row].threadImage == "" {
            return 176
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if arrayOfCellData[indexPath.row].threadImage == "" {
            return 176
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func didPressButton(_ tag: Int, _ cell: FeedTableViewCell) {
        print("I have pressed a button with a tag: \(tag)")
        let actionController = YoutubeActionController()
        
        var trackMsg = "Track this thread"
        
        if arrayOfCellData[tag].tracked as Bool {
            //Already tracking
            trackMsg = "Tracking this thread"
            actionController.addAction(Action(ActionData(title: trackMsg, image: UIImage(named: "Checkmark-50")!), style: .default, handler: { action in
                HUD.show(.progress)
                
                let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "untrack_thread")
                request.validate()
                request.responseJSON { response in
                    if response.error != nil {
                        self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        if let jsonValue = response.result.value {
                            var results = JSON(jsonValue)
                            if results["response"].boolValue {
                                HUD.flash(.success, delay: 1.0)
                                self.arrayOfCellData[tag].tracked = false
                            } else {
                                HUD.flash(.label("Something went wrong :("), delay: 1.0)
                            }
                        }
                    }
                }
            }))
        } else {
            //Not tracked
            actionController.addAction(Action(ActionData(title: trackMsg, image: UIImage(named: "Binoculars")!), style: .default, handler: { action in
                HUD.show(.progress)

                let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "track_thread")
                request.validate()
                request.responseJSON { response in
                    if response.error != nil {
                        self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        if let jsonValue = response.result.value {
                            var results = JSON(jsonValue)
                            if results["response"].boolValue {
                                HUD.flash(.success, delay: 1.0)
                                self.arrayOfCellData[tag].tracked = true
                            } else {
                                HUD.flash(.label("Something went wrong :("), delay: 1.0)
                            }
                        }
                    }
                }
            }))
        }
        
        
        var readMsg: String = "Add to reading list"
        if arrayOfCellData[tag].isRead as Bool {
            //Added to reading list
            readMsg = "Added to reading list"
            actionController.addAction(Action(ActionData(title: readMsg, image: UIImage(named: "Checkmark-50")!), style: .default, handler: { action in
                HUD.show(.progress)
                
                let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "remove_from_list")
                request.validate()
                request.responseJSON { response in
                    if response.error != nil {
                        self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        if let jsonValue = response.result.value {
                            var results = JSON(jsonValue)
                            if results["response"].boolValue {
                                HUD.flash(.success, delay: 1.0)
                                self.arrayOfCellData[tag].isRead = false
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.refreshReadingList = true
                            } else {
                                HUD.flash(.label("Something went wrong :("), delay: 1.0)
                            }
                        }
                    }
                }
            }))
        } else {
            //Add to reading list
            actionController.addAction(Action(ActionData(title: readMsg, image: UIImage(named: "Reading")!), style: .default, handler: { action in
                HUD.show(.progress)
                
                let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "add_to_list")
                request.validate()
                request.responseJSON { response in
                    if response.error != nil {
                        self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        if let jsonValue = response.result.value {
                            var results = JSON(jsonValue)
                            if results["response"].boolValue {
                                HUD.flash(.success, delay: 1.0)
                                self.arrayOfCellData[tag].isRead = true
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.refreshReadingList = true
                            } else {
                                HUD.flash(.label("Something went wrong :("), delay: 1.0)
                            }
                        }
                    }
                }
            }))
        }
        
        actionController.addAction(Action(ActionData(title: "Hide this thread", image: UIImage(named: "Hide")!), style: .default, handler: { action in
            let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to hide this thread?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "HIDE", style: .destructive, handler: { action in
                
                HUD.show(.progress)
                
                let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "hide_thread")
                request.validate()
                request.responseJSON { response in
                    if response.error != nil {
                        self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        if let jsonValue = response.result.value {
                            var results = JSON(jsonValue)
                            if results["response"].boolValue {
                                HUD.flash(.success, delay: 1.0)
                                let indexPath = self.feedTableView.indexPath(for: cell)
                                self.arrayOfCellData.remove(at: tag)
                                self.feedTableView.deleteRows(at: [indexPath!], with: .automatic)
                            } else {
                                HUD.flash(.label("Something went wrong :("), delay: 1.0)
                            }
                        }
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }))
        
        if arrayOfCellData[tag].userid as Int == Int(userinfoArr[0]) {
            actionController.addAction(Action(ActionData(title: "Delete this thread", image: UIImage(named: "Delete_Colored")!), style: .destructive, handler: { action in
                
                let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "DELETE", style: .destructive, handler: { action in
                    
                    HUD.show(.progress)
                    
                    let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "delete_thread")
                    request.validate()
                    request.responseJSON { response in
                        if response.error != nil {
                            self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                        } else {
                            if let jsonValue = response.result.value {
                                var results = JSON(jsonValue)
                                if results["response"].boolValue {
                                    HUD.flash(.success, delay: 1.0)
                                    let indexPath = self.feedTableView.indexPath(for: cell)
                                    self.arrayOfCellData.remove(at: tag)
                                    self.feedTableView.deleteRows(at: [indexPath!], with: .automatic)
                                } else {
                                    HUD.flash(.label("Something went wrong :("), delay: 1.0)
                                }
                            }
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }))
        }
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "Cancel")!), style: .cancel, handler: { action in
            print("Pressed cancel")
        }))
        
        self.present(actionController, animated: true, completion: nil)
    }
    
    func didPressButtonWithoutImage(_ tag: Int, _ cell: FeedCellWithoutImageTableViewCell) {
        print("I have pressed a button with a tag: \(tag)")
        let actionController = YoutubeActionController()
        
        var trackMsg = "Track this thread"
        
        if arrayOfCellData[tag].tracked as Bool {
            //Already tracking
            trackMsg = "Tracking this thread"
            actionController.addAction(Action(ActionData(title: trackMsg, image: UIImage(named: "Checkmark-50")!), style: .default, handler: { action in
                HUD.show(.progress)
                
                let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "untrack_thread")
                request.validate()
                request.responseJSON { response in
                    if response.error != nil {
                        self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        if let jsonValue = response.result.value {
                            var results = JSON(jsonValue)
                            if results["response"].boolValue {
                                HUD.flash(.success, delay: 1.0)
                                self.arrayOfCellData[tag].tracked = false
                            } else {
                                HUD.flash(.label("Something went wrong :("), delay: 1.0)
                            }
                        }
                    }
                }
            }))
        } else {
            //Not tracked
            actionController.addAction(Action(ActionData(title: trackMsg, image: UIImage(named: "Binoculars")!), style: .default, handler: { action in
                HUD.show(.progress)
                
                let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "track_thread")
                request.validate()
                request.responseJSON { response in
                    if response.error != nil {
                        self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        if let jsonValue = response.result.value {
                            var results = JSON(jsonValue)
                            if results["response"].boolValue {
                                HUD.flash(.success, delay: 1.0)
                                self.arrayOfCellData[tag].tracked = true
                            } else {
                                HUD.flash(.label("Something went wrong :("), delay: 1.0)
                            }
                        }
                    }
                }
            }))
        }
        
        
        var readMsg: String = "Add to reading list"
        if arrayOfCellData[tag].isRead as Bool {
            //Added to reading list
            readMsg = "Added to reading list"
            actionController.addAction(Action(ActionData(title: readMsg, image: UIImage(named: "Checkmark-50")!), style: .default, handler: { action in
                HUD.show(.progress)
                
                let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "remove_from_list")
                request.validate()
                request.responseJSON { response in
                    if response.error != nil {
                        self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        if let jsonValue = response.result.value {
                            var results = JSON(jsonValue)
                            if results["response"].boolValue {
                                HUD.flash(.success, delay: 1.0)
                                self.arrayOfCellData[tag].isRead = false
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.refreshReadingList = true
                            } else {
                                HUD.flash(.label("Something went wrong :("), delay: 1.0)
                            }
                        }
                    }
                }
            }))
        } else {
            //Add to reading list
            actionController.addAction(Action(ActionData(title: readMsg, image: UIImage(named: "Reading")!), style: .default, handler: { action in
                HUD.show(.progress)
                
                let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "add_to_list")
                request.validate()
                request.responseJSON { response in
                    if response.error != nil {
                        self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        if let jsonValue = response.result.value {
                            var results = JSON(jsonValue)
                            if results["response"].boolValue {
                                HUD.flash(.success, delay: 1.0)
                                self.arrayOfCellData[tag].isRead = true
                                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                appDelegate.refreshReadingList = true
                            } else {
                                HUD.flash(.label("Something went wrong :("), delay: 1.0)
                            }
                        }
                    }
                }
            }))
        }
        
        actionController.addAction(Action(ActionData(title: "Hide this thread", image: UIImage(named: "Hide")!), style: .default, handler: { action in
            let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to hide this thread?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "HIDE", style: .destructive, handler: { action in
                
                HUD.show(.progress)
                
                let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "hide_thread")
                request.validate()
                request.responseJSON { response in
                    if response.error != nil {
                        self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                    } else {
                        if let jsonValue = response.result.value {
                            var results = JSON(jsonValue)
                            if results["response"].boolValue {
                                HUD.flash(.success, delay: 1.0)
                                let indexPath = self.feedTableView.indexPath(for: cell)
                                self.arrayOfCellData.remove(at: tag)
                                self.feedTableView.deleteRows(at: [indexPath!], with: .automatic)
                            } else {
                                HUD.flash(.label("Something went wrong :("), delay: 1.0)
                            }
                        }
                    }
                }
            }))
            alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }))
        
        if arrayOfCellData[tag].userid as Int == Int(userinfoArr[0]) {
            actionController.addAction(Action(ActionData(title: "Delete this thread", image: UIImage(named: "Delete_Colored")!), style: .destructive, handler: { action in
                
                let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "DELETE", style: .destructive, handler: { action in
                    
                    HUD.show(.progress)
                    
                    let request = self.api.threadOptions(tid: self.arrayOfCellData[tag].threadno, option: "delete_thread")
                    request.validate()
                    request.responseJSON { response in
                        if response.error != nil {
                            self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                        } else {
                            if let jsonValue = response.result.value {
                                var results = JSON(jsonValue)
                                if results["response"].boolValue {
                                    HUD.flash(.success, delay: 1.0)
                                    let indexPath = self.feedTableView.indexPath(for: cell)
                                    self.arrayOfCellData.remove(at: tag)
                                    self.feedTableView.deleteRows(at: [indexPath!], with: .automatic)
                                } else {
                                    HUD.flash(.label("Something went wrong :("), delay: 1.0)
                                }
                            }
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }))
        }
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "Cancel")!), style: .cancel, handler: { action in
            print("Pressed cancel")
        }))
        
        self.present(actionController, animated: true, completion: nil)
    }
}
