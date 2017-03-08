//
//  SignUpViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/8/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    let api = Api()
    
    let correctImage = #imageLiteral(resourceName: "check-25")
    let incorrectImage = #imageLiteral(resourceName: "Cancel-25")
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.rightViewMode = UITextFieldViewMode.always
        password.rightViewMode = UITextFieldViewMode.always
        confirmPassword.rightViewMode = UITextFieldViewMode.always
        
        username.setBottomBorder()
        password.setBottomBorder()
        confirmPassword.setBottomBorder()
        
        username.addTarget(self, action: #selector(usernameTextFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        username.becomeFirstResponder()
        
        self.hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
        
    @IBAction func goBack(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func setRightModeImage(textField: UITextField, image: UIImage) {
        imageView.image = image
        textField.rightView = imageView
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.username {
            if self.username.returnKeyType == UIReturnKeyType.next {
                self.password.becomeFirstResponder()
            }
        }
        else if textField == self.password {
            if self.password.returnKeyType == UIReturnKeyType.next {
                self.confirmPassword.becomeFirstResponder()
            }
        }
        else if textField == self.confirmPassword {
            if self.confirmPassword.returnKeyType == UIReturnKeyType.go {
                register()
            }
        }
        return true
    }
        
    
    func usernameTextFieldDidChange(_ textField: UITextField) {
        if textField.text != "" {
            print(textField.text!)
            if (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! >= 5 {
                textField.rightView?.isHidden = false
                let request = api.checkUsername(username: textField.text!)
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
                                self.setRightModeImage(textField: textField, image: self.incorrectImage)
                            }
                            else {
                                self.setRightModeImage(textField: textField, image: self.correctImage)
                            }
                        }
                    }
                }
            }
            else {
                textField.rightView?.isHidden = true
//                self.setRightModeImage(textField: textField, image: self.incorrectImage)
            }
        }
    }
    
    func register() {
        print("Make Register API call")
    }
    
    @IBAction func handleRegister(_ sender: Any) {
        let imageV = UIImageView(image: UIImage(named: "check-25"))
        if username.rightView! == imageV && (username.text?.lengthOfBytes(using: .utf8))! >= 5 && (password.text?.lengthOfBytes(using: .utf8))! >= 8 && (confirmPassword.text?.lengthOfBytes(using: .utf8))! >= 8 && password.text == confirmPassword.text {
            self.register()
        }
        else {
            var errorMsg: String = ""
                        
            if username.rightView! != imageV {
                errorMsg = "Username already exists."
            }
            
            if password.text != confirmPassword.text {
                errorMsg = "Passwords do not match."
            }
            
            if (password.text?.lengthOfBytes(using: .utf8))! < 8 || (confirmPassword.text?.lengthOfBytes(using: .utf8))! < 8 {
                errorMsg = "Password must be min 8 characters long."
            }
            
            if (username.text?.lengthOfBytes(using: .utf8))! < 5 {
                errorMsg = "Username must be min 5 characters long."
            }
            
            let alertContoller = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertContoller.addAction(defaultAction)
            self.present(alertContoller, animated: true, completion: nil)
        }
    }
}
