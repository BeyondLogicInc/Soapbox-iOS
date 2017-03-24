//
//  StatsViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/24/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

struct topThreadsData {
    
}

struct topRepliesData {
    
}

class StatsViewController: UIViewController {

    @IBOutlet weak var threadCount: UILabel!
    @IBOutlet weak var replyCount: UILabel!
    @IBOutlet weak var statsTableView: UITableView!
    
    let api = Api()
    let totalThreads: Int! = nil
    let totalReplies: Int! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
