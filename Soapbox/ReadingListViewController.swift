//
//  ReadingListViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/18/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import PKHUD

struct readingListData {
    let threadno: String!
    let threadTitle: String!
    let avatarImage: UIImage!
    let timeElapsed: String!
    let userid: String!
    let name: String!
}

class ReadingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var readingListTableView: UITableView!
    let noDataView = UIView()
    
    let loader = UIActivityIndicatorView()
    let api = Api()
    var arrayOfReadingListData = [readingListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noDataView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        readingListTableView.tableFooterView = UIView()
        
        //Initialize loader
        loader.frame = CGRect(x: 0, y: -65.0, width: self.view.frame.width, height: self.view.frame.height)
        loader.isHidden = false
        loader.hidesWhenStopped = true
        loader.backgroundColor = UIColor.white
        loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.loader.startAnimating()
        
        populateReadingList()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.refreshReadingList {
            self.arrayOfReadingListData.removeAll()
            self.view.bringSubview(toFront: loader)
            self.loader.startAnimating()
            populateReadingList()
            appDelegate.refreshReadingList = false
        } else {
            print("No new items added")
        }
    }

    func populateReadingList() {
        let request = api.populateReadingList()
        request.validate()
        request.responseJSON { response in
            if response.error != nil {
                self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
            } else {
                if let jsonValue = response.result.value {
                    let results = JSON(jsonValue)["results"]
                    if results.count > 0 {
                        self.noDataView.removeFromSuperview()
                        for item in results.arrayValue {
                            let url = URL(string: self.api.BASE_URL + item["avatarpath"].stringValue)
                            let data = try? Data(contentsOf: url!)
                            self.arrayOfReadingListData.append(readingListData(threadno: item["srno"].stringValue, threadTitle: item["title"].stringValue, avatarImage: UIImage(data: data!), timeElapsed: item["timestamp"].stringValue, userid: item["uid"].stringValue, name: item["fname"].stringValue + " " + item["lname"].stringValue))
                        }
                        self.loader.stopAnimating()
                        self.readingListTableView.reloadData()
                        return
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
        noDataLabel.text = "No threads added to Reading list"
        noDataLabel.frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 20)
        noDataLabel.font = UIFont(name: "OpenSans", size: 15.0)!
        noDataLabel.textAlignment = NSTextAlignment.center
        noDataView.addSubview(noDataLabel)
        self.view.addSubview(noDataView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfReadingListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "readingListCell", for: indexPath) as! ReadingListTableViewCell
        
        cell.avatarImageView.image = arrayOfReadingListData[indexPath.row].avatarImage
        cell.threadTitle.text = arrayOfReadingListData[indexPath.row].threadTitle
        cell.timeElapsedLabel.text = arrayOfReadingListData[indexPath.row].timeElapsed
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Remove") { (action, indexPath) in
            
            HUD.show(.progress)
            let request = self.api.threadOptions(tid: self.arrayOfReadingListData[indexPath.row].threadno, option: "remove_from_list")
            request.validate()
            request.responseJSON { response in
                if response.error != nil {
                    self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                } else {
                    if let jsonValue = response.result.value {
                        var results = JSON(jsonValue)
                        if results["response"].boolValue {
                            HUD.flash(.success, delay: 1.0)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.refreshReadingList = true
                            
                            self.arrayOfReadingListData.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            if self.arrayOfReadingListData.count == 0 {
                                self.loadNoDataView()
                            }
                        } else {
                            HUD.flash(.label("Something went wrong :("), delay: 1.0)
                        }
                    }
                }
            }
            
        }
        delete.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        return [delete]
    }
}
