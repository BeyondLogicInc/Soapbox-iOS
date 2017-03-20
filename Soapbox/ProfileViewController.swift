//
//  ProfileViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/10/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import KeyClip

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profileTableView: UITableView!
    let profileCellTextArray: [String] = ["Drafts", "Stats", "Follow your interests", "Settings", "Help", "Sign Out"]
    var avatar: UIImage!
    var userinfoArr = [String]()
    let api = Api()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.tableFooterView = UIView()
        avatar = api.getImage()
        userinfoArr = api.getUserInfoFromKeychain()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleSignOut() {
        let request = api.logout()
        request.validate()
        request.responseJSON { response in
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell1", for: indexPath) as! ViewProfileCustomCell
            cell.avatarImage.image = avatar
            cell.userFullName.text = userinfoArr[1] + " " + userinfoArr[2]
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell2", for: indexPath)
            cell.textLabel?.text = self.profileCellTextArray[indexPath.row]
            cell.textLabel?.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            cell.textLabel?.font = UIFont(name: "OpenSans", size: 14.0)!
            return cell
        }
        else {
            preconditionFailure("Unexpected Cell")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat!
        if indexPath.section == 0 {
            height = 80
        } else {
            height = 55
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            if indexPath.row == 5 {
                handleSignOut()
            } else if indexPath.row == 2 {
                self.performSegue(withIdentifier: "toCategoriesVC", sender: nil)
            }
        }
    }
}
