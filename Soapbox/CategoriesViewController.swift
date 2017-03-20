//
//  CategoriesViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/20/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import PKHUD

struct categoryData {
    let srno: Int!
    let name: String!
    let image: UIImage!
    let threadcount: Int!
    let usercount: Int!
    let uid: String!
}

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCategoryCellDelegate {

    @IBOutlet weak var categoryTableView: UITableView!
    
    let api = Api()
    var arrayOfCategoryData = [categoryData]()
    var selectedCategories: [Int] = []
    var userinfoArr = [String]()
    let loader = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userinfoArr = api.getUserInfoFromKeychain()
        
        loader.frame = CGRect(x: 0, y: -65.0, width: self.view.frame.width, height: self.view.frame.height)
        loader.isHidden = false
        loader.hidesWhenStopped = true
        loader.backgroundColor = UIColor.white
        loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.loader.startAnimating()
        
        getCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getCategories() {
        let request = api.getCategoriesFollowing()
        request.validate()
        request.responseJSON { response in
            if response.error != nil {
                
            }
            else {
                if let jsonValue = response.result.value {
                    let results = JSON(jsonValue)["results"]
                    if results.count > 0 {
                        for item in results.arrayValue {
                            let url = URL(string: self.api.BASE_URL + item["imagepath"].stringValue)
                            let data = try? Data(contentsOf: url!)
                            self.arrayOfCategoryData.append(categoryData(srno: item["srno"].intValue, name: item["name"].stringValue, image: UIImage(data: data!), threadcount: item["thread_count"].intValue, usercount: item["user_count"].intValue, uid: item["uid"].stringValue))
                            if item["uid"].stringValue == self.userinfoArr[0] {
                                self.selectedCategories.append(item["srno"].intValue)
                            }
                        }                        
                        self.loader.stopAnimating()
                        self.categoryTableView.reloadData()
                        return
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCategoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCustomCell", for: indexPath) as! CategoryCustomTableViewCell

        cell.cellDelegate = self
        cell.tag = indexPath.row
        
        if arrayOfCategoryData[indexPath.row].uid == userinfoArr[0] {
            cell.categoryFollowButton.setTitle("Unfollow", for: .normal)
        } else {
            cell.categoryFollowButton.setTitle("Follow", for: .normal)
        }
        
        cell.categoryThumbnail.image = arrayOfCategoryData[indexPath.row].image
        cell.categoryTitle.text = arrayOfCategoryData[indexPath.row].name
        
        var threadCountTxt = JSON(arrayOfCategoryData[indexPath.row].threadcount).stringValue
        if arrayOfCategoryData[indexPath.row].threadcount == 1 {
            threadCountTxt = threadCountTxt + " Thread"
        } else {
            threadCountTxt = threadCountTxt + " Threads"
        }
        cell.threadCountLabel.text = threadCountTxt
        
        var userCountTxt = JSON(arrayOfCategoryData[indexPath.row].usercount).stringValue
        if arrayOfCategoryData[indexPath.row].usercount == 1 {
            userCountTxt = userCountTxt + " User"
        } else {
            userCountTxt = userCountTxt + " Users"
        }
        cell.userCountLabel.text = userCountTxt
        
        return cell
    }
 
    func didPressButton(_ tag: Int, _ cell: CategoryCustomTableViewCell) {        
        
        let indexPath = self.categoryTableView.indexPathForRow(at: cell.center)!
        let selectedItem = arrayOfCategoryData[indexPath.row].srno
        
        if selectedCategories.contains(selectedItem!) {
            selectedCategories = selectedCategories.filter({ $0 != selectedItem })
        }
        else {
            selectedCategories.append(selectedItem!)
        }
        print(selectedCategories)
    }
}
