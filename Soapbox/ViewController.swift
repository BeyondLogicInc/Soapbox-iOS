//
//  ViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/3/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func signOut(_ sender: Any) {
        keychain.delete("soapbox.user.id")
        self.performSegue(withIdentifier: "toLoginViewSegue", sender: nil)
    }
}
