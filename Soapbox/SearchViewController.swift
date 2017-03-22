//
//  SearchViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/22/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

struct searchThreadResults {
    let threadno: String!
    let title: String!
    let description: String!
    let timestamp: String!
    let upvotes: String!
    let replies: String!
    let views: String!
    let uid: String!
    let name: String!
    let avatarpath: String!
    let cname: String!
}

class SearchViewController: UIViewController, UISearchBarDelegate, UITabBarDelegate, UITableViewDataSource {
 
    @IBOutlet weak var searchThreadsTableView: UITableView!
    
    @IBOutlet weak var threadsFilterButton: UIButton!
    @IBOutlet weak var peopleFilterButton: UIButton!
    @IBOutlet weak var tagsFilterButton: UIButton!
    
    let searchBar = UISearchBar()
    let btnBorderBottomColor: UIColor = UIColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
    let btnBorderBottomColorActive: UIColor = UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    
    var searchActive : Bool = false
    var arrayOfSearchedThreads = [searchThreadResults]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchBar()
        
        searchThreadsTableView.separatorColor = UIColor.clear
        searchThreadsTableView.isHidden = true
        
        threadsFilterButton.setBottomBorder(color: btnBorderBottomColorActive)
        peopleFilterButton.setBottomBorder(color: btnBorderBottomColor)
        tagsFilterButton.setBottomBorder(color: btnBorderBottomColor)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initSearchBar() {
        searchBar.delegate = self        
        searchBar.placeholder = "Search Soapbox"
        searchBar.backgroundImage = UIImage()
        searchBar.changeSearchBarColor(color: #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1))
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        self.navigationItem.hidesBackButton = true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        searchBar.showsScopeBar = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        searchBar.showsScopeBar = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchActive = false;
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchThreadsTableView.isHidden = false
        
        if searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            arrayOfSearchedThreads.removeAll()
        } else {
            let encodedAdress = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        }
    }
    
    @IBAction func filterChanged(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
    
        switch button.tag {
            case 1:
                threadsFilterButton.setBottomBorder(color: btnBorderBottomColorActive)
                peopleFilterButton.setBottomBorder(color: btnBorderBottomColor)
                tagsFilterButton.setBottomBorder(color: btnBorderBottomColor)
                break
            case 2:
                threadsFilterButton.setBottomBorder(color: btnBorderBottomColor)
                peopleFilterButton.setBottomBorder(color: btnBorderBottomColorActive)
                tagsFilterButton.setBottomBorder(color: btnBorderBottomColor)
                break
            case 3:
                threadsFilterButton.setBottomBorder(color: btnBorderBottomColor)
                peopleFilterButton.setBottomBorder(color: btnBorderBottomColor)
                tagsFilterButton.setBottomBorder(color: btnBorderBottomColorActive)
                break
            default:
                print("Unknown language")
            return
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        
        if tableView == searchThreadsTableView {
            count = arrayOfSearchedThreads.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchThreadsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchThreadCell", for: indexPath) as! SearchThreadTableViewCell
            return cell
        }
        
        else { preconditionFailure ("unexpected cell type") }
    }
}

extension UISearchBar {
    func changeSearchBarColor(color : UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                
                if let _ = subSubView as? UITextInputTraits {
                    let textField = subSubView as! UITextField
                    textField.backgroundColor = color
                    break
                }
                
            }
        }
    }
}

extension UIButton {
    func setBottomBorder(color: UIColor) {
        self.layer.backgroundColor = UIColor.clear.cgColor
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomLine)
    }
}
