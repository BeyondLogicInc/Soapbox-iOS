//
//  Extensions.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/6/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    static func showErrorAlert(errorMsg: String) -> UIAlertController {
        let alertContoller = UIAlertController(title: "Error", message: errorMsg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertContoller.addAction(defaultAction)
        return alertContoller
    }
}

class Time {
    static func delay(_ delay: Double, closure:@escaping () -> Void) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.clear.cgColor
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor(colorLiteralRed: 204/255, green: 204/255, blue: 204/255, alpha: 1.0).cgColor
        self.layer.addSublayer(bottomLine)
    }
}

extension String {
    
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
