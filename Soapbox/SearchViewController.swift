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
    let loader = UIActivityIndicatorView()
    
    let btnBorderBottomColor: UIColor = UIColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
    let btnBorderBottomColorActive: UIColor = UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    
    let api = Api()
    var searchActive : Bool = false
    var arrayOfSearchedThreads = [searchThreadResults]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSearchBar()
        
        initLoader()
        
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
    
    func initLoader() {
        loader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - 65)
        loader.isHidden = false
        loader.hidesWhenStopped = true
        loader.backgroundColor = UIColor.white
        loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        loader.stopAnimating()
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
        arrayOfSearchedThreads.removeAll()
        searchThreadsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchThreadsTableView.isHidden = false
        loader.startAnimating()
        
        if searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            arrayOfSearchedThreads.removeAll()
            loader.stopAnimating()
        } else {
            let encodedAdress = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            arrayOfSearchedThreads.removeAll()
            
            let request = api.searchAll(key: encodedAdress)
            request.validate()
            request.responseJSON { response in
                if response.error != nil {
                    self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                } else {
                    if let jsonValue = response.result.value {
                        let results = JSON(jsonValue)["response"]
                        if results["threads"].count > 0 {
                            let searchedThreads = results["threads"]
                            for item in searchedThreads.arrayValue {
                                self.arrayOfSearchedThreads.append(searchThreadResults(threadno: item["srno"].stringValue, title: item["title"].stringValue, description: item["description"].stringValue, timestamp: item["timestamp"].stringValue, upvotes: item["upvotes"].stringValue, replies: item["replies"].stringValue, views: item["views"].stringValue, uid: item["uid"].stringValue, name: item["name"].stringValue, avatarpath: item["avatarpath"].stringValue, cname: item["cname"].stringValue))
                            }
                            self.loader.stopAnimating()
                            self.searchThreadsTableView.reloadData()
                            
                        } else if results["people"].count > 0 {
                            
                        } else if results["tags"].count > 0 {
                            
                        }
                    }
                }
            }
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
                searchThreadsTableView.isHidden = false
                break
            case 2:
                threadsFilterButton.setBottomBorder(color: btnBorderBottomColor)
                peopleFilterButton.setBottomBorder(color: btnBorderBottomColorActive)
                tagsFilterButton.setBottomBorder(color: btnBorderBottomColor)
                searchThreadsTableView.isHidden = true
                break
            case 3:
                threadsFilterButton.setBottomBorder(color: btnBorderBottomColor)
                peopleFilterButton.setBottomBorder(color: btnBorderBottomColor)
                tagsFilterButton.setBottomBorder(color: btnBorderBottomColorActive)
                searchThreadsTableView.isHidden = true
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
            
            cell.feedOwnerImage.sd_setImage(with: URL(string: api.BASE_URL + arrayOfSearchedThreads[indexPath.row].avatarpath))
            cell.feedOwnerName.text = arrayOfSearchedThreads[indexPath.row].name
            cell.category.text = arrayOfSearchedThreads[indexPath.row].cname
            cell.timeElapsed.text = arrayOfSearchedThreads[indexPath.row].timestamp
            cell.threadTitle.text = arrayOfSearchedThreads[indexPath.row].title
            cell.threadDescription.text = arrayOfSearchedThreads[indexPath.row].description
            cell.upvotes.text = arrayOfSearchedThreads[indexPath.row].upvotes + " Upvotes"
            cell.replies.text = arrayOfSearchedThreads[indexPath.row].replies + " Replies"
            cell.views.text = arrayOfSearchedThreads[indexPath.row].views + " Views"
            
            cell.contentView.backgroundColor = UIColor.init(colorLiteralRed: 234/255, green: 233/255, blue: 237/255, alpha: 1.0)
            
            return cell
        }
        
        else { preconditionFailure ("unexpected cell type") }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
