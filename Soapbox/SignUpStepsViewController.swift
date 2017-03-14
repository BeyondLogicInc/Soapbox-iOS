//
//  SignUpStepsViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/14/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class SignUpStepsViewController: UIViewController {

    @IBOutlet var signUpViewStep1: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(signUpViewStep1)
        signUpViewStep1.center = self.view.center
        
        self.hideKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
