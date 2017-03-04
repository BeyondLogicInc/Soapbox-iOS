//
//  ViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/3/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.setBottomBorder()
        password.setBottomBorder()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(_ sender: Any) {
    }

}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.clear.cgColor
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        self.layer.addSublayer(bottomLine)
    }
}
