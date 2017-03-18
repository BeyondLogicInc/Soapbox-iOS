//
//  ReadingListViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/18/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

struct readingListData {
    let threadTitle: String!
    let avatarImage: UIImage!
    let timeElapsed: String!
}

class ReadingListViewController: UIViewController {
    
    @IBOutlet weak var readingListTableView: UITableView!
    
    let api = Api()
    var arrayOfReadingListData = [readingListData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if appDelegate.refreshReadingList {
            print("Need to refresh reading list")
        } else {
            print("No new items added")
        }
    }

    func populateReadingList() {
        
    }
}
