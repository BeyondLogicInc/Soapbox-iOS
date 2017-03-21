//
//  FeaturedThreadsViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/21/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

struct featuredThreadsData {
    let srno: String!
    let title: String!
    let uid: String!
    let username: String!
    let name: String!
//    let avatarpath: String!
}

class FeaturedThreadsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var featuredThreadsTableView: UITableView!
    let api = Api()
    var arrayOfFeaturedThreads = [featuredThreadsData]()
    let loader = UIActivityIndicatorView()
    let noDataView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        featuredThreadsTableView.tableFooterView = UIView()
        
        noDataView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        //Initialize loader
        loader.frame = CGRect(x: 0, y: -65.0, width: self.view.frame.width, height: self.view.frame.height)
        loader.isHidden = false
        loader.hidesWhenStopped = true
        loader.backgroundColor = UIColor.white
        loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.loader.startAnimating()
        
        getFeaturedThreads()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getFeaturedThreads() {
        let request = api.getFeaturedThreads()
        request.validate()
        request.responseJSON { response in
            if response.error != nil {
                self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
            } else {
                if let jsonValue = response.result.value {
                    let results = JSON(jsonValue)["results"]
                    if results.count > 0 {
                        for item in results.arrayValue {
                            self.arrayOfFeaturedThreads.append(featuredThreadsData(srno: item["srno"].stringValue, title: item["title"].stringValue, uid: item["uid"].stringValue, username: item["username"].stringValue, name: item["fname"].stringValue + " " + item["lname"].stringValue))
                        }
                        self.loader.stopAnimating()
                        self.featuredThreadsTableView.reloadData()
                    } else {
                        self.loader.stopAnimating()
                        self.loadNoDataView()
                    }
                }
            }
        }
    }
    
    func loadNoDataView() {
        noDataView.backgroundColor = #colorLiteral(red: 0.9342361093, green: 0.9314675331, blue: 0.9436802864, alpha: 1)
        let noDataLabel = UILabel()
        noDataLabel.text = "No Featured threads for today"
        noDataLabel.frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 20)
        noDataLabel.font = UIFont(name: "OpenSans", size: 15.0)!
        noDataLabel.textAlignment = NSTextAlignment.center
        noDataView.addSubview(noDataLabel)
        self.view.addSubview(noDataView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfFeaturedThreads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "featuredThreadCell", for: indexPath) as! FeaturedThreadsTableViewCell
        
        cell.indexNumber.text = JSON(indexPath.row + 1).stringValue
        cell.threadTitle.text = arrayOfFeaturedThreads[indexPath.row].title
        cell.threadOwner.text = arrayOfFeaturedThreads[indexPath.row].name
        
        return cell
    }
    
}
