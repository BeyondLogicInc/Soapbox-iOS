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
    let description: String!
    let timestamp: String!
    let upvotes: String!
    let name: String!
}

class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var threadCount: UILabel!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var statsTableView: UITableView!
    
    let loader = UIActivityIndicatorView()
    
    let api = Api()
    var totalThreads: Int = 0
    var totalReplies: Int = 0
    
    var arrayOfTopThreads = [topThreadsData]()
    var arrayOfTopReplies = [topRepliesData]()
    
    let sections = ["Top Threads", "Top Replies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize loader
        loader.frame = CGRect(x: 0, y: -65.0, width: self.view.frame.width, height: self.view.frame.height)
        loader.isHidden = false
        loader.hidesWhenStopped = true
        loader.backgroundColor = UIColor.white
        loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.loader.startAnimating()
        
        threadCount.text = JSON(totalThreads).stringValue
        replyCount.text = JSON(totalReplies).stringValue
        
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
                    
                    let topThreads = results["top_threads"]
                    let topReplies = results["top_replies"]
                    
                    if topThreads.count > 0 {
                        for item in topThreads.arrayValue {
                            self.arrayOfTopThreads.append(topThreadsData(threadno: item["srno"].stringValue, title: item["title"].stringValue, timestamp: item["timestamp"].stringValue, upvotes: item["upvotes"].stringValue, name: item["name"].stringValue))
                        }
                    }
                    
                    if topReplies.count > 0 {
                        for item in topReplies.arrayValue {
                            self.arrayOfTopReplies.append(topRepliesData(replyno: item["srno"].stringValue, description: item["description"].stringValue, timestamp: item["timestamp"].stringValue, upvotes: item["upvotes"].stringValue, name: item["name"].stringValue))
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! StatsTableViewCell
            
            cell.upvoteCount.text = arrayOfTopReplies[indexPath.row].upvotes
            cell.title.text = arrayOfTopReplies[indexPath.row].description
            cell.name.text = arrayOfTopThreads[indexPath.row].name
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.backgroundColor = UIColor.white
        header.textLabel?.font = UIFont(name: "OpenSans", size: 14)
    }
}
