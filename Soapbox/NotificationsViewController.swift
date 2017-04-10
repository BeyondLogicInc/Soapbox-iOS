//
//  NotificationsViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/29/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

struct notificationsData {
    let threadno: String!
    let ref: String!
    let type: String!
    let read: String!
    let timestamp: String!
    let avatarImage: UIImage!
    let notificationContent: String!
}

class NotificationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var notificationsTableView: UITableView!
    let api = Api()
    let loader = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    let noDataView = UIView()
    var arrayOfNotificationsData = [notificationsData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(NotificationsViewController.pullToRefresh), for: .valueChanged)
        
        noDataView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        notificationsTableView.tableFooterView = UIView()
        
        //Initialize loader
        loader.frame = CGRect(x: 0, y: -65.0, width: self.view.frame.width, height: self.view.frame.height)
        loader.isHidden = false
        loader.hidesWhenStopped = true
        loader.backgroundColor = UIColor.white
        loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.loader.startAnimating()

        getNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadNoDataView() {
        noDataView.backgroundColor = #colorLiteral(red: 0.9342361093, green: 0.9314675331, blue: 0.9436802864, alpha: 1)
        let noDataLabel = UILabel()
        noDataLabel.text = "No notifications to display"
        noDataLabel.frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 20)
        noDataLabel.font = UIFont(name: "OpenSans", size: 15.0)!
        noDataLabel.textAlignment = NSTextAlignment.center
        noDataView.addSubview(noDataLabel)
        self.view.addSubview(noDataView)
    }
    
    func getNotifications() {
        let request = api.getNotifications()
        request.validate()
        request.responseJSON { response in
            if response.error != nil {
                self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
            } else {
                if let jsonValue = response.result.value {
                    let results = JSON(jsonValue)["results"]
                    if results.count > 0 {
                        for item in results.arrayValue {
                            let url = URL(string: self.api.BASE_URL + item["avatarpath"].stringValue)
                            let data = try? Data(contentsOf: url!)
                            self.arrayOfNotificationsData.append(notificationsData(threadno: item["tid"].stringValue, ref: item["ref"].stringValue, type: item["type"].stringValue, read: item["read"].stringValue, timestamp: item["timestamp"].stringValue, avatarImage: UIImage(data: data!), notificationContent: item["content"].stringValue))
                        }
                        self.loader.stopAnimating()
                        self.notificationsTableView.reloadData()
                    } else {
                        self.loader.stopAnimating()
                        self.loadNoDataView()
                    }
                }
            }
        }
    }
    
    func pullToRefresh() {
        arrayOfNotificationsData.removeAll()
        getNotifications()
        refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfNotificationsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell", for: indexPath) as! NotificationTableViewCell
        
        cell.avatarImage.image = arrayOfNotificationsData[indexPath.row].avatarImage
        let attributedContent = (arrayOfNotificationsData[indexPath.row].notificationContent).html2AttributedString
        cell.notificationContent.lineBreakMode = .byTruncatingTail
        cell.notificationContent.attributedText = attributedContent
        cell.timestamp.text = arrayOfNotificationsData[indexPath.row].timestamp
        
        if JSON(arrayOfNotificationsData[indexPath.row].read).intValue == 0 {
            cell.backgroundColor = #colorLiteral(red: 0.9176470588, green: 0.9137254902, blue: 0.9294117647, alpha: 1)
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
