//
//  LoginViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/4/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import KeyClip

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLoggedIn()                
        
        username.setBottomBorder()
        password.setBottomBorder()
        
        self.hideKeyboard()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkLoggedIn() {
        if KeyClip.exists("soapbox.userdata") {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabView") as? UITabBarController else {
                print("could not instantiate controller")
                return
            }
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
        else {
            print("no value in keychain")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.username {
            if self.username.returnKeyType == UIReturnKeyType.next {
                self.password.becomeFirstResponder()
            }
        }
        else if textField == self.password {
            if self.password.returnKeyType == UIReturnKeyType.go {
                login()
            }
        }
        return true
    }
    
    @IBAction func backToLoginView(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func handleLogin(_ sender: Any) {
        login()
    }
    
    func login() {
        if KeyClip.save("soapbox.userdata", dictionary: ["userid":"10002","username":"sipps7","fname":"Atharva","lname":"Dandekar","avatarpath":"steve.jpg"]
            ) {
            let dict = KeyClip.load("soapbox.userdata") as NSDictionary!
            var json = JSON(dict!)
            print(json["username"].stringValue)
            self.performSegue(withIdentifier: "toTabViewSegue", sender: nil)
        }
        else {
            print("Error setting keychain")
        }
    }
    
}

class SignUpController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        username.setBottomBorder()
        password.setBottomBorder()
        confirmPassword.setBottomBorder()
        
        username.becomeFirstResponder()
        self.hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.view.endEditing(true)
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
    
    func register() {
        
    }
    
    @IBAction func handleRegister(_ sender: Any) {
        register()
    }
}
