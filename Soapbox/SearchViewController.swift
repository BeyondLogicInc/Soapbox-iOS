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

struct searchPeopleResults {
    let srno: String!
    let name: String!
    let username: String!
    let avatarpath: String!
    let about: String!
}

struct searchTagsResults {
    let name: String!
}

class SearchViewController: UIViewController, UISearchBarDelegate, UITabBarDelegate, UITableViewDataSource {
 
    @IBOutlet weak var searchThreadsTableView: UITableView!
    @IBOutlet var searchPeopleTableView: UITableView!
    @IBOutlet var searchTagsTableView: UITableView!
    
    @IBOutlet weak var threadsFilterButton: UIButton!
    @IBOutlet weak var peopleFilterButton: UIButton!
    @IBOutlet weak var tagsFilterButton: UIButton!
    
    let searchBar = UISearchBar()
    let loader = UIActivityIndicatorView()
    let noDataView = UIView()
    let noDataLabel = UILabel()
    
    let btnBorderBottomColor: UIColor = UIColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
    let btnBorderBottomColorActive: UIColor = UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    
    let api = Api()
    var searchActive : Bool = false
    var selectedFilter: Int = 1
    
    var arrayOfSearchedThreads = [searchThreadResults]()
    var arrayOfSearchedPeople = [searchPeopleResults]()
    var arrayOfSearchedTags = [searchTagsResults]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(searchPeopleTableView)
        self.view.addSubview(searchTagsTableView)
        
        searchPeopleTableView.frame = CGRect(x: 0, y: 45, width: self.view.frame.width, height: 509)
        searchTagsTableView.frame = CGRect(x: 0, y: 45, width: self.view.frame.width, height: 509)
        
        searchPeopleTableView.tableFooterView = UIView()
        searchTagsTableView.tableFooterView = UIView()
        
        initSearchBar()
        
        initLoader()
        
        searchThreadsTableView.separatorColor = UIColor.clear
        searchThreadsTableView.isHidden = true
        searchPeopleTableView.isHidden = true
        searchTagsTableView.isHidden = true
        
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
    
    func loadNoDataView() {
        noDataView.backgroundColor = #colorLiteral(red: 0.9342361093, green: 0.9314675331, blue: 0.9436802864, alpha: 1)
        noDataLabel.text = ""
        noDataLabel.frame = CGRect(x: 0, y: self.view.frame.height/2, width: self.view.frame.width, height: 20)
        noDataLabel.font = UIFont(name: "OpenSans", size: 15.0)!
        noDataLabel.textAlignment = NSTextAlignment.center
        noDataView.addSubview(noDataLabel)
        self.view.addSubview(noDataView)
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
        searchBar.showsScopeBar = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchActive = false;
        searchBar.endEditing(true)
        arrayOfSearchedThreads.removeAll()
        arrayOfSearchedPeople.removeAll()
        arrayOfSearchedTags.removeAll()
        searchThreadsTableView.reloadData()
        searchPeopleTableView.reloadData()
        searchTagsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchThreadsTableView.isHidden = false
        loader.startAnimating()
        
        if searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            arrayOfSearchedThreads.removeAll()
            arrayOfSearchedPeople.removeAll()
            arrayOfSearchedTags.removeAll()
            loader.stopAnimating()
        } else {
            let encodedAdress = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            arrayOfSearchedThreads.removeAll()
            arrayOfSearchedPeople.removeAll()
            arrayOfSearchedTags.removeAll()
            
            let request = api.searchAll(key: encodedAdress)
            request.validate()
            request.responseJSON { response in
                if response.error != nil {
                    self.present(Alert.showErrorAlert(errorMsg: (response.error?.localizedDescription)!), animated: true, completion: nil)
                } else {
                    if let jsonValue = response.result.value {
                        let results = JSON(jsonValue)["response"]
                        
                        if results["threads"].count <= 0 && results["people"].count <= 0 && results["tags"].count <= 0 {
                            self.loader.stopAnimating()
                            self.searchThreadsTableView.isHidden = true
                            self.searchPeopleTableView.isHidden = true
                            self.searchTagsTableView.isHidden = true
                            self.loadNoDataView()
                        } else {
                            if results["threads"].count > 0 {
//                                self.noDataView.removeFromSuperview()
                                let searchedThreads = results["threads"]
                                for item in searchedThreads.arrayValue {
                                    self.arrayOfSearchedThreads.append(searchThreadResults(threadno: item["srno"].stringValue, title: item["title"].stringValue, description: item["description"].stringValue, timestamp: item["timestamp"].stringValue, upvotes: item["upvotes"].stringValue, replies: item["replies"].stringValue, views: item["views"].stringValue, uid: item["uid"].stringValue, name: item["name"].stringValue, avatarpath: item["avatarpath"].stringValue, cname: item["cname"].stringValue))
                                }
                                
                            } else {
                                self.searchThreadsTableView.isHidden = true
//                                self.noDataView.removeFromSuperview()
//                                self.loadNoDataView()
                            }
                            
                            if results["people"].count > 0 {
//                                self.noDataView.removeFromSuperview()
                                let searchedPeople = results["people"]
                                for item in searchedPeople.arrayValue {                                    self.arrayOfSearchedPeople.append(searchPeopleResults(srno: item["srno"].stringValue, name: item["name"].stringValue, username: item["username"].stringValue, avatarpath: item["avatarpath"].stringValue, about: item["about"].stringValue))
                                }
                            } else {
                                self.searchPeopleTableView.isHidden = true
//                                self.noDataView.removeFromSuperview()
//                                self.loadNoDataView()
                            }
                            
                            if results["tags"].count > 0 {
//                                self.noDataView.removeFromSuperview()
                                let searchedTags = results["tags"]
                                for item in searchedTags.arrayValue {
                                    self.arrayOfSearchedTags.append(searchTagsResults(name: item["name"].stringValue))
                                }
                            } else {
                                self.searchTagsTableView.isHidden = true
//                                self.noDataView.removeFromSuperview()
//                                self.loadNoDataView()
                            }
                            
                            self.loader.stopAnimating()
                            
                            if self.selectedFilter == 1 {
                                if self.arrayOfSearchedThreads.count <= 0 {
                                    self.noDataView.removeFromSuperview()
                                    self.loadNoDataView()
                                    self.noDataLabel.text = "Couldn't find Threads"
                                } else {
                                    self.noDataView.removeFromSuperview()
                                }
                            } else if self.selectedFilter == 2 {
                                if self.arrayOfSearchedPeople.count <= 0 {
                                    self.noDataView.removeFromSuperview()
                                    self.loadNoDataView()
                                    self.noDataLabel.text = "Couldn't find People"
                                } else {
                                    self.noDataView.removeFromSuperview()
                                }
                            } else if self.selectedFilter == 3 {
                                if self.arrayOfSearchedTags.count <= 0 {
                                    self.noDataView.removeFromSuperview()
                                    self.loadNoDataView()
                                    self.noDataLabel.text = "Couldn't find Tags"
                                } else {
                                    self.noDataView.removeFromSuperview()
                                }
                            }
                            
                            self.searchThreadsTableView.reloadData()
                            self.searchPeopleTableView.reloadData()
                            self.searchTagsTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    func hideAllTableViews() {
        searchThreadsTableView.isHidden = true
        searchPeopleTableView.isHidden = true
        searchTagsTableView.isHidden = true
    }
    
    @IBAction func filterChanged(sender: AnyObject) {
        guard let button = sender as? UIButton else {
            return
        }
    
        switch button.tag {
            case 1:
                selectedFilter = 1
                
                threadsFilterButton.setBottomBorder(color: btnBorderBottomColorActive)
                peopleFilterButton.setBottomBorder(color: btnBorderBottomColor)
                tagsFilterButton.setBottomBorder(color: btnBorderBottomColor)
                if searchActive {
                    searchThreadsTableView.isHidden = false
                    searchPeopleTableView.isHidden = true
                    searchTagsTableView.isHidden = true
                    
                    if arrayOfSearchedThreads.count <= 0 {
                        self.noDataView.removeFromSuperview()
                        self.loadNoDataView()
                        self.noDataLabel.text = "Couldn't find Threads"
                    } else {
                        self.noDataView.removeFromSuperview()
                    }
                    
                } else {
                    hideAllTableViews()
                }
                break
            case 2:
                selectedFilter = 2
                
                threadsFilterButton.setBottomBorder(color: btnBorderBottomColor)
                peopleFilterButton.setBottomBorder(color: btnBorderBottomColorActive)
                tagsFilterButton.setBottomBorder(color: btnBorderBottomColor)
                if searchActive {
                    searchThreadsTableView.isHidden = true
                    searchPeopleTableView.isHidden = false
                    searchTagsTableView.isHidden = true
                    
                    if arrayOfSearchedPeople.count <= 0 {
                        self.noDataView.removeFromSuperview()
                        self.loadNoDataView()
                        self.noDataLabel.text = "Couldn't find People"
                    } else {
                        self.noDataView.removeFromSuperview()
                    }
                    
                } else {
                    hideAllTableViews()
                }
                break
            case 3:
                selectedFilter = 3
                
                threadsFilterButton.setBottomBorder(color: btnBorderBottomColor)
                peopleFilterButton.setBottomBorder(color: btnBorderBottomColor)
                tagsFilterButton.setBottomBorder(color: btnBorderBottomColorActive)
                if searchActive {
                    searchThreadsTableView.isHidden = true
                    searchPeopleTableView.isHidden = true
                    searchTagsTableView.isHidden = false
                    
                    if arrayOfSearchedTags.count <= 0 {
                        self.noDataView.removeFromSuperview()
                        self.loadNoDataView()
                        self.noDataLabel.text = "Couldn't find Tags"
                    } else {
                        self.noDataView.removeFromSuperview()
                    }
                    
                } else {
                    hideAllTableViews()
                }
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
        } else if tableView == searchPeopleTableView {
            count = arrayOfSearchedPeople.count
        } else if tableView == searchTagsTableView {
            count = arrayOfSearchedTags.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == searchThreadsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchThreadCell", for: indexPath) as! SearchThreadTableViewCell
            
            cell.feedOwnerImage.sd_setImage(with: URL(string: api.BASE_URL + arrayOfSearchedThreads[indexPath.row].avatarpath), placeholderImage: #imageLiteral(resourceName: "avatar_male"))
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
        } else if tableView == searchPeopleTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchPeopleCell", for: indexPath) as! SearchPeopleTableViewCell
            
            cell.name.text = arrayOfSearchedPeople[indexPath.row].name
            cell.avatarImage.sd_setImage(with: URL(string: api.BASE_URL + arrayOfSearchedPeople[indexPath.row].avatarpath), placeholderImage: #imageLiteral(resourceName: "avatar_male"))
            cell.about.text = arrayOfSearchedPeople[indexPath.row].about
            
            return cell
        } else if tableView == searchTagsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchTagCell", for: indexPath)
            cell.textLabel?.text = arrayOfSearchedTags[indexPath.row].name
            cell.textLabel?.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            cell.textLabel?.font = UIFont(name: "OpenSans", size: 14.0)!
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
