//
//  SearchViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/22/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
 
    @IBOutlet weak var threadsFilterButton: UIButton!
    
    @IBOutlet weak var peopleFilterButton: UIButton!
    
    @IBOutlet weak var tagsFilterButton: UIButton!
    
    let searchBar = UISearchBar()
    let btnBorderBottomColor: UIColor = UIColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
    let btnBorderBottomColorActive: UIColor = UIColor(colorLiteralRed: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchBar()
        
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
