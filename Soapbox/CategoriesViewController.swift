//
//  CategoriesViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/20/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

struct categoryData {
    let srno: Int!
    let name: String!
    let image: UIImage!
    let threadcount: Int!
    let usercount: Int!
}

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryTableView: UITableView!
    let api = Api()
    var arrayOfCategoryData = [categoryData]()
    let loader = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let request = api.getCategories()
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
                            self.arrayOfCategoryData.append(categoryData(srno: item["srno"].intValue, name: item["name"].stringValue, image: UIImage(data: data!), threadcount: item["thread_count"].intValue, usercount: item["user_count"].intValue))
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
        
        cell.categoryThumbnail.image = arrayOfCategoryData[indexPath.row].image
        cell.categoryTitle.text = arrayOfCategoryData[indexPath.row].name
        
        return cell
    }
    
}
