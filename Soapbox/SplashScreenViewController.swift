//
//  SplashScreenViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/10/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import RevealingSplashView
import KeyClip

class SplashScreenViewController: UIViewController {
    
    var userinfoArr = [String]()
    let api = Api()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "Icon-App-60x60")!,iconInitialSize: CGSize(width: 60, height: 60), backgroundColor: UIColor.init(red: 51/255, green: 52/255, blue: 52/255, alpha: 1.0))
        revealingSplashView.animationType = .squeezeAndZoomOut
        self.view.addSubview(revealingSplashView)
        revealingSplashView.startAnimation(){
            print("Completed")
            self.checkLoggedIn()
        }
    }
    
    func checkLoggedIn() {
        if KeyClip.exists("soapbox.userdata") {
            userinfoArr = api.getUserInfoFromKeychain()
            if userinfoArr[1] == "" || userinfoArr[2] == "" {
                self.performSegue(withIdentifier: "toSignUpStepsVC", sender: nil)
            } else {
                self.performSegue(withIdentifier: "toTabViewController", sender: nil)
            }
        }
        else {
            self.performSegue(withIdentifier: "toHeadNavigation", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
