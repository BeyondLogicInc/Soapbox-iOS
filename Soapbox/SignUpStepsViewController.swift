//
//  SignUpStepsViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/14/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class SignUpStepsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    /*
        STEP 1 Outlets
    */
    @IBOutlet var signUpViewStep1: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var aboutYouTextField: UITextField!
    @IBOutlet weak var step1ScrollView: UIScrollView!
    
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
        
        self.hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
}
