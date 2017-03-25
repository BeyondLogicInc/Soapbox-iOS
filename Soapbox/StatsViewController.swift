//
//  StatsViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/24/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

struct topThreadsData {
    let threadno: String!
    let title: String!
    let timestamp: String!
    let upvotes: String!
    let name: String!
}

struct topRepliesData {
    let replyno: String!
    let threadno: String!
    let description: String!
    let timestamp: String!
    let upvotes: String!
    let name: String!
}

struct correctRepliesData {
    let replyno: String!
    let threadno: String!
    let description: String!
    let timestamp: String!
    let upvotes: String!
    let name: String!
}

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var statsHeaderView: UIView!
    
    @IBOutlet weak var threadCount: UILabel!
    @IBOutlet weak var correctReplyCount: UILabel!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var statsTableView: UITableView!
    
    let loader = UIActivityIndicatorView()
    
    let api = Api()
    
    var arrayOfTopThreads = [topThreadsData]()
    var arrayOfTopReplies = [topRepliesData]()
    var arrayOfCorrectReplies = [correctRepliesData]()
    
    let sections = ["Top Threads", "Correct Replies", "Top Replies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statsHeaderView.addBorder(side: .bottom, thickness: 1.0, color: #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1))
        statsTableView.tableFooterView = UIView()
        //Initialize loader
        loader.frame = CGRect(x: 0, y: -65.0, width: self.view.frame.width, height: self.view.frame.height)
        loader.isHidden = false
        loader.hidesWhenStopped = true
        loader.backgroundColor = UIColor.white
        loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.loader.startAnimating()
        
        getStats()
    }
    
    func getStats() {
        let request = api.getStats()
        request.validate()
        request.responseJSON { response in
            if response.error != nil {
                self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
            } else {
                if let jsonValue = response.result.value {
                    let results = JSON(jsonValue)
                    
                    self.threadCount.text = JSON(results["thread_count"].intValue).stringValue
                    self.replyCount.text = JSON(results["reply_count"].intValue).stringValue
                    self.correctReplyCount.text = JSON(results["correct_reply_count"].intValue).stringValue
                    
                    let topThreads = results["top_threads"]
                    let topReplies = results["top_replies"]
                    let correctReplies = results["correct_replies"]
                    
                    if topThreads.count > 0 {
                        for item in topThreads.arrayValue {
                            self.arrayOfTopThreads.append(topThreadsData(threadno: item["srno"].stringValue, title: item["title"].stringValue, timestamp: item["timestamp"].stringValue, upvotes: item["upvotes"].stringValue, name: item["name"].stringValue))
                        }
                    }
                    
                    if topReplies.count > 0 {
                        for item in topReplies.arrayValue {
                            self.arrayOfTopReplies.append(topRepliesData(replyno: item["srno"].stringValue, threadno: item["tid"].stringValue,description: item["description"].stringValue, timestamp: item["timestamp"].stringValue, upvotes: item["upvotes"].stringValue, name: item["name"].stringValue))
                        }
                    }
                    
                    if correctReplies.count > 0 {
                        for item in correctReplies.arrayValue {
                            self.arrayOfCorrectReplies.append(correctRepliesData(replyno: item["srno"].stringValue, threadno: item["tid"].stringValue,description: item["description"].stringValue, timestamp: item["timestamp"].stringValue, upvotes: item["upvotes"].stringValue, name: item["name"].stringValue))
                        }
                    }
                    
                    self.loader.stopAnimating()
                    self.statsTableView.reloadData()
                    return
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrayOfTopThreads.count
        } else if section == 1 {
            return arrayOfCorrectReplies.count
        } else {
            return arrayOfTopReplies.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! StatsTableViewCell
            
            cell.upvoteCount.text = arrayOfTopThreads[indexPath.row].upvotes
            cell.title.text = arrayOfTopThreads[indexPath.row].title
            cell.name.text = arrayOfTopThreads[indexPath.row].name
            
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! StatsTableViewCell
            
            cell.upvoteCount.text = arrayOfCorrectReplies[indexPath.row].upvotes
            cell.title.text = arrayOfCorrectReplies[indexPath.row].description
            cell.name.text = arrayOfCorrectReplies[indexPath.row].name
            
            return cell
        
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! StatsTableViewCell
            
            cell.upvoteCount.text = arrayOfTopReplies[indexPath.row].upvotes
            cell.title.text = arrayOfTopReplies[indexPath.row].description
            cell.name.text = arrayOfTopThreads[indexPath.row].name
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view
        header.addBorder(side: .bottom, thickness: 1.0, color: #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1))
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let lbl = UILabel(frame: CGRect(x: 16,y: 3, width: self.view.frame.size.width,height: 20))
        lbl.textColor = UIColor.darkText
        lbl.font = UIFont(name: "OpenSans", size: 14)
        if section == 0 {
            lbl.text = "Top Threads"
        } else if section == 1{
            lbl.text = "Correct Replies"
        } else {
            lbl.text = "Top Replies"
        }
        
        headerView.addSubview(lbl)
        headerView.isOpaque = true
        headerView.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
