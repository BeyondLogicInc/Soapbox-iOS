//
//  Api.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/7/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import Foundation
import Alamofire
import KeyClip

class Api {
    
    var BASE_URL: String = "http://192.168.0.104/Soapboxv2/"
    
    public func validateLogin(username: String, password: String) -> DataRequest {
        let params: Parameters = ["uname":username, "pword":password]
        let request = Alamofire.request(BASE_URL + "Login/process", method: .post, parameters: params)
        return request
    }
    
    public func getUserInfoFromKeychain() -> [String] {
        let userinfo = KeyClip.load("soapbox.userdata") as String?
        let userinfoArr = userinfo?.components(separatedBy: "|")
        return userinfoArr!
    }
    
    public func logout() -> DataRequest {
        let request = Alamofire.request(BASE_URL + "Logout")
        return request
    }
}
