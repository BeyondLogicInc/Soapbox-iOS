//
//  SignUpStepsViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/14/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

struct categoryInfo {
    let srno: Int!
    let name: String!
    let image: UIImage!
    let threadcount: Int!
    let usercount: Int!
}

class SignUpStepsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, categoryCellDelegate {

    /*
        STEP 1, STEP 2 Outlets
    */
    @IBOutlet var signUpViewStep1: UIView!
    @IBOutlet var signUpViewStep2: UIView!
    @IBOutlet weak var categoryInfoTableView: UITableView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var aboutYouTextField: UITextField!
    
    let api = Api()
    var arrayOfCategories = [categoryInfo]()
    var selectedCategories: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* STEP 1 init */
        self.view.addSubview(signUpViewStep1)
        signUpViewStep1.center = self.view.center
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.avatarImageTapped(_:)))
        avatarImageView.addGestureRecognizer(tapGesture)
        
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        
        firstNameTextField.setBottomBorder()
        lastNameTextField.setBottomBorder()
        emailTextField.setBottomBorder()
        aboutYouTextField.setBottomBorder()
        
        if genderSegmentedControl.selectedSegmentIndex == 0 {
            genderSegmentedControl.tintColor = #colorLiteral(red: 0.1058823529, green: 0.631372549, blue: 0.8862745098, alpha: 1)
        }
        else if genderSegmentedControl.selectedSegmentIndex == 1 {
            genderSegmentedControl.tintColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.7058823529, alpha: 1)
        }
        
        /* STEP 2 init */
        categoryInfoTableView.backgroundColor = UIColor.clear
        categoryInfoTableView.delegate = self
        categoryInfoTableView.dataSource = self
        DispatchQueue.main.async {
            self.getCategories()
        }
        
        self.hideKeyboard()
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
                            self.arrayOfCategories.append(categoryInfo(srno: item["srno"].intValue, name: item["name"].stringValue, image: UIImage(data: data!), threadcount: item["thread_count"].intValue, usercount: item["user_count"].intValue))
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func genderChanged(_ sender: Any) {
        if genderSegmentedControl.selectedSegmentIndex == 0 {
            genderSegmentedControl.tintColor = #colorLiteral(red: 0.1058823529, green: 0.631372549, blue: 0.8862745098, alpha: 1)
        }
        else if genderSegmentedControl.selectedSegmentIndex == 1 {
            genderSegmentedControl.tintColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.7058823529, alpha: 1)
        }
    }
    
    func avatarImageTapped(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        /*
            STEP 1 TextFields
        */
        if textField == self.emailTextField || textField == self.aboutYouTextField {
            UIView.animate(withDuration: 0.4) {
                self.signUpViewStep1.frame = CGRect(x: self.signUpViewStep1.frame.origin.x, y: -176, width: self.signUpViewStep1.frame.width, height: self.signUpViewStep1.frame.height)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*
            STEP 1 TextFields
         */
        UIView.animate(withDuration: 0.4) {
            self.signUpViewStep1.center = self.view.center
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /*
            STEP 1 TextFields
         */
        if textField == firstNameTextField {
            if firstNameTextField.returnKeyType == UIReturnKeyType.next {
                lastNameTextField.becomeFirstResponder()
            }
        }
        else if textField == lastNameTextField {
            if lastNameTextField.returnKeyType == UIReturnKeyType.next {
                emailTextField.becomeFirstResponder()
            }
        }
        else if textField == emailTextField {
            if emailTextField.returnKeyType == UIReturnKeyType.next {
                aboutYouTextField.becomeFirstResponder()
            }
        }
        else if textField == aboutYouTextField {
            
        }
        
        return true
    }
    
    func emailTextFieldDidChange(_ textField: UITextField) {
        if (textField.text?.lengthOfBytes(using: .utf8))! >= 1 {
            
        }
    }
    
    @IBAction func step1NextBtnPressed(_ sender: Any) {
        var errorMsg: String = ""
        
        if firstNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            errorMsg = "Please enter correct credentials"
            self.present(Alert.showErrorAlert(errorMsg: errorMsg), animated: true, completion: nil)
        } else {
            animateSteps(view1: signUpViewStep1, view2: signUpViewStep2)
            categoryInfoTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "signUpCategoryCell", for: indexPath) as! SignUpCategoryTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        cell.categoryImageView.clipsToBounds = true
        cell.selectionStyle = .none
        
        if selectedCategories.contains(arrayOfCategories[indexPath.row].srno) {
            cell.selectedCategoryImage.image = #imageLiteral(resourceName: "Ok-50")
        } else {
            cell.selectedCategoryImage.image = nil
        }
        
        cell.categoryImageView.image = arrayOfCategories[indexPath.row].image
        cell.categoryName.text = arrayOfCategories[indexPath.row].name
        
        var threadCountTxt = JSON(arrayOfCategories[indexPath.row].threadcount).stringValue
        if arrayOfCategories[indexPath.row].threadcount == 1 {
            threadCountTxt = threadCountTxt + " Thread"
        } else {
            threadCountTxt = threadCountTxt + " Threads"
        }
        cell.categoryThreadCount.text = threadCountTxt
        
        var userCountTxt = JSON(arrayOfCategories[indexPath.row].usercount).stringValue
        if arrayOfCategories[indexPath.row].usercount == 1 {
            userCountTxt = userCountTxt + " User"
        } else {
            userCountTxt = userCountTxt + " Users"
        }
        cell.categoryUserCount.text = userCountTxt
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear        
    }
    
    func categoryCellDelegate(_ tag: Int, _ cell: SignUpCategoryTableViewCell) {
        
        let indexPath = self.categoryInfoTableView.indexPathForRow(at: cell.center)!
        let selectedItem = arrayOfCategories[indexPath.row].srno
                
        if selectedCategories.contains(selectedItem!) {
            selectedCategories = selectedCategories.filter({ $0 != selectedItem })
        }
        else {
            selectedCategories.append(selectedItem!)
        }
        self.categoryInfoTableView.reloadData()
        print(selectedCategories)
    }
    
    @IBAction func step2BackBtnPressed(_ sender: Any) {
        animateSteps(view1: signUpViewStep2, view2: signUpViewStep1)
    }
    
    func animateSteps(view1: UIView, view2: UIView) {
        view1.removeFromSuperview()
        self.view.addSubview(view2)
        view2.center = self.view.center
    }
    
}
