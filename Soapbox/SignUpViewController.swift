//
//  SignUpViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/8/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import KeyClip

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerActivityIndicator: UIActivityIndicatorView!
    
    let api = Api()
    
    let correctImage = #imageLiteral(resourceName: "check-25")
    let incorrectImage = #imageLiteral(resourceName: "Cancel-25")
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    var userExistsFlag: Bool = false
    
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
        
    
    @objc func usernameTextFieldDidChange(_ textField: UITextField) {
        if textField.text != "" {
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
                                self.userExistsFlag = true
                            }
                            else {
                                self.setRightModeImage(textField: textField, image: self.correctImage)
                                self.userExistsFlag = false
                            }
                        }
                    }
                }
            }
            else {
                textField.rightView?.isHidden = true
            }
        }
    }
    
    func register() {
        self.registerButton.isHidden = true
        self.registerActivityIndicator.isHidden = false
        self.registerActivityIndicator.startAnimating()

        let request = api.signup(username: username.text!, password: password.text!, confirmPassword: confirmPassword.text!)
        request.validate()
        request.responseJSON { response in
            if response.error != nil {
                let error: String = (response.error?.localizedDescription)!
                self.present(Alert.showErrorAlert(errorMsg: error), animated: true, completion: nil)
                self.registerActivityIndicator.stopAnimating()
                self.registerButton.isHidden = false
            } else {
                if let jsonValue = response.result.value {
                    let results = JSON(jsonValue)
                    
                    let userdata: String = "\(results["userid"])|\(results["fname"])|\(results["lname"])|\(results["username"])|\(results["avatarpath"])"
                    
                    if KeyClip.save("soapbox.userdata", string: userdata) {
                        let userinfo = KeyClip.load("soapbox.userdata") as String?
                        print(userinfo!)
                        self.registerActivityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "toSignUpStepsVC", sender: nil)
                    } else {
                        self.present(Alert.showErrorAlert(errorMsg: "Error saving in keychain"), animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func handleRegister(_ sender: Any) {
        self.register()
        /*var errorMsg: String = ""
        
        if username.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || password.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || confirmPassword.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            errorMsg = "Please enter correct credentials"
            self.present(Alert.showErrorAlert(errorMsg: errorMsg), animated: true, completion: nil)
        }
        else if password.text != confirmPassword.text {
            errorMsg = "Passwords do not match."
            self.present(Alert.showErrorAlert(errorMsg: errorMsg), animated: true, completion: nil)
        }
        else if userExistsFlag {
            errorMsg = "Username already exists"
            self.present(Alert.showErrorAlert(errorMsg: errorMsg), animated: true, completion: nil)
        }
        else if !self.userExistsFlag && (username.text?.lengthOfBytes(using: .utf8))! >= 5 && (password.text?.lengthOfBytes(using: .utf8))! >= 8 && (confirmPassword.text?.lengthOfBytes(using: .utf8))! >= 8 && password.text == confirmPassword.text {
            self.register()
        }*/
    }
}
