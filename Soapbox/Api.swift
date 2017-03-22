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
//    var BASE_URL: String = "https://api-soapbox.herokuapp.com/"
    let AVATAR_NAME: String = "avatarpath.jpg"
    
    public func validateLogin(username: String, password: String) -> DataRequest {
        let params: Parameters = ["uname":username, "pword":password]
        let request = Alamofire.request(BASE_URL + "Login/process", method: .post, parameters: params)
        return request
    }
    
    public func signup(username: String, password: String, confirmPassword: String) -> DataRequest {
        let params: Parameters = ["nusername": username, "npassword": password, "cpassword": confirmPassword]
        let request = Alamofire.request(BASE_URL + "Login/signup", method: .post, parameters: params)
        return request
    }
        
    public func logout() -> DataRequest {
        let request = Alamofire.request(BASE_URL + "Logout")
        return request
    }
    
    public func checkUsername(username: String) -> DataRequest {
        let params: Parameters = ["uname": username]
        let request = Alamofire.request(BASE_URL + "Ajax_Controller/checkUsername", method: .post, parameters: params)
        return request
    }
    
    public func populateThreads() -> DataRequest {
        let request = Alamofire.request(BASE_URL + "Thread/getThreads")
        return request
    }
    
    public func getFeaturedThreads() -> DataRequest {
        let request = Alamofire.request(BASE_URL + "Thread/getFeaturedThreads")
        return request
    }
    
    public func populateReadingList() -> DataRequest {
        let request = Alamofire.request(BASE_URL + "Ajax_Controller/getReadingList")
        return request
    }
    
    public func getCategories() -> DataRequest {
        let request = Alamofire.request(BASE_URL + "Signup/getCategories")
        return request
    }
    
    public func getCategoriesFollowing() -> DataRequest {
        let request = Alamofire.request(BASE_URL + "Categories/getCategoriesFollowing")
        return request
    }
    
    public func updateCategories(categories: String) -> DataRequest {
        let params: Parameters = ["categories": categories]
        let request = Alamofire.request(BASE_URL + "Ajax_Controller/update_categories", method: .post, parameters: params)
        return request
    }
    
    public func emailExists(email: String) -> DataRequest {
        let params: Parameters = ["email": email]
        let request = Alamofire.request(BASE_URL + "Ajax_Controller/email_exists", method: .post, parameters: params)
        return request
    }
    
    public func threadOptions(tid: String, option: String) -> DataRequest {
        let params: Parameters = ["tid": tid]
        let request = Alamofire.request(BASE_URL + "Ajax_Controller/thread_options/\(option)", method: .post, parameters: params)
        return request
    }
    
    public func searchAll(key: String) -> DataRequest {
        let params: Parameters = ["key": key]
        let request = Alamofire.request(BASE_URL + "Ajax_Controller/search_all", method: .post, parameters: params)
        return request
    }
    
    public func getUserInfoFromKeychain() -> [String] {
        let userinfo = KeyClip.load("soapbox.userdata") as String?
        let userinfoArr = userinfo?.components(separatedBy: "|")
        return userinfoArr!
    }
    
    public func saveImageDocumentDirectory(image: UIImage) {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(AVATAR_NAME)
        let image = image
        print(paths)
        let imageData = UIImageJPEGRepresentation(image, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    public func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    public func getImage() -> UIImage {
        let fileManager = FileManager.default
        let imagePath = (getDirectoryPath() as NSString).appendingPathComponent(AVATAR_NAME)
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)!
        } else {
            return UIImage(named: "blur")!
        }
    }
    
    public func deleteImage() {
        let fileManager = FileManager.default
        let imagePath = (getDirectoryPath() as NSString).appendingPathComponent(AVATAR_NAME)
        if fileManager.fileExists(atPath: imagePath) {
            try! fileManager.removeItem(atPath: imagePath)
        } else {
            print("Something went wrong")
        }
    }
}
