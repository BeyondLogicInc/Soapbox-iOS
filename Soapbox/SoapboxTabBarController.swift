//
//  SoapboxTabBarController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 4/10/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import Alamofire

class SoapboxTabBarController: UITabBarController {

    let api = Api()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUnreadNotificationCount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getUnreadNotificationCount() {
        let request = api.getUnreadNotificationCount()
        request.validate()
        request.responseJSON { response in
            if response.error != nil {
                
            } else {
                if let jsonValue = response.result.value {
                    self.appDelegate.unreadNotificationCount = JSON(jsonValue)["count"].stringValue
                    if JSON(self.appDelegate.unreadNotificationCount).intValue > 0 {
                        self.tabBar.items?[3].badgeValue = self.appDelegate.unreadNotificationCount
                    } else {
                        self.tabBar.items?[3].badgeValue = nil
                    }
                }
            }
        }
    }
    
}
