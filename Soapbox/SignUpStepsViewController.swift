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
    let count: Int!
}

class SignUpStepsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {

    /*
        STEP 1 Outlets
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
    @IBOutlet weak var step1ScrollView: UIScrollView!
    
    let api = Api()
    var arrayOfCategories = [categoryInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* STEP 1 init */
        self.view.addSubview(signUpViewStep1)
        signUpViewStep1.center = self.view.center
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.avatarImageTapped(_:)))
        avatarImageView.addGestureRecognizer(tapGesture)
        
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
                            self.arrayOfCategories.append(categoryInfo(srno: item["srno"].intValue, name: item["name"].stringValue, image: UIImage(data: data!), count: item["count"].intValue))
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
                self.step1ScrollView.frame = CGRect(x: 20, y: -176, width: self.step1ScrollView.frame.width, height: self.step1ScrollView.frame.height)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*
            STEP 1 TextFields
         */
        UIView.animate(withDuration: 0.4) {
            self.step1ScrollView.frame = CGRect(x: 20, y: 20, width: self.step1ScrollView.frame.width, height: self.step1ScrollView.frame.height)
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
    
    @IBAction func step1NextBtnPressed(_ sender: Any) {
        animateSteps(view1: signUpViewStep1, view2: signUpViewStep2)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "signUpCategoryCell", for: indexPath) as! SignUpCategoryTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        cell.categoryImageView.image = arrayOfCategories[indexPath.row].image
        cell.categoryName.text = arrayOfCategories[indexPath.row].name
        cell.categoryThreadCount.text = JSON(arrayOfCategories[indexPath.row].count).stringValue + " Threads"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
 
    @IBAction func step2BackBtnPressed(_ sender: Any) {
        animateSteps(view1: signUpViewStep2, view2: signUpViewStep1)
    }
    
    func animateSteps(view1: UIView, view2: UIView) {
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            view1.transform = CGAffineTransform.init(scaleX: 0.01, y: 0.01)
        }) { (success: Bool) in
            view1.removeFromSuperview()
            self.view.addSubview(view2)
            view2.center = self.view.center
            view2.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                view2.alpha = 1
                view2.transform = CGAffineTransform.identity
            }) { (success: Bool ) in
                
            }
        }
    }
    
}
