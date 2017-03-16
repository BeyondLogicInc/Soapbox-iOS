//
//  SignUpStepsViewController.swift
//  Soapbox
//
//  Created by Atharva Dandekar on 3/14/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import Alamofire
import KeyClip

struct categoryInfo {
    let srno: Int!
    let name: String!
    let image: UIImage!
    let threadcount: Int!
    let usercount: Int!
}

class SignUpStepsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, categoryCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    /*
        STEP 1, STEP 2 Outlets
    */
    @IBOutlet var signUpViewStep1: UIView!
    @IBOutlet var signUpViewStep2: UIView!
    @IBOutlet weak var categoryInfoTableView: UITableView!
    
    @IBOutlet weak var step1BannerLabel: UILabel!
    @IBOutlet weak var step2BannerLabel: UILabel!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var aboutYouTextField: UITextField!
    @IBOutlet weak var securityQuestionToggleBtn: UIButton!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var questionPickerView: UIPickerView!
    @IBOutlet weak var step2DoneBtn: SoapboxButton!
    @IBOutlet weak var saveInfoIndicator: UIActivityIndicatorView!
    
    let api = Api()
    
    var userinfoArr = [String]()
    var questions: [String] = [String]()
    
    let correctImage = #imageLiteral(resourceName: "check-25")
    let incorrectImage = #imageLiteral(resourceName: "Cancel-25")
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    var avatarImageName: String = ""
    
    var arrayOfCategories = [categoryInfo]()
    var selectedCategories: [Int] = []
    var selectedQuestion: Int = 0
    var emailExistsFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userinfoArr = api.getUserInfoFromKeychain()
        questions = ["What was your childhood nickname?","What is your birthplace?","What is the name of your best friend?", "What is your first school's name?", "Who is your childhood hero?", "In what town was your first job?", "What is your pet's name?", "What is your father's middle name?", "What is your favorite food?", "Who was your favorite teacher?"]
        step1BannerLabel.text = "Hi there, \(userinfoArr[3])"
        step2BannerLabel.text = "Hi there, \(userinfoArr[3])"
        
        /* STEP 1 init */
        self.view.addSubview(signUpViewStep1)
        signUpViewStep1.center = self.view.center
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.avatarImageTapped(_:)))
        avatarImageView.addGestureRecognizer(tapGesture)
        
        emailTextField.rightViewMode = UITextFieldViewMode.always
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        
        firstNameTextField.setBottomBorder()
        lastNameTextField.setBottomBorder()
        emailTextField.setBottomBorder()
        aboutYouTextField.setBottomBorder()
        answerTextField.setBottomBorder()
        
        if genderSegmentedControl.selectedSegmentIndex == 0 {
            genderSegmentedControl.tintColor = #colorLiteral(red: 0.1058823529, green: 0.631372549, blue: 0.8862745098, alpha: 1)
        }
        else if genderSegmentedControl.selectedSegmentIndex == 1 {
            genderSegmentedControl.tintColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.7058823529, alpha: 1)
        }
        
        questionPickerView.isHidden = true
        
        /* STEP 2 init */
        categoryInfoTableView.backgroundColor = UIColor.clear
        categoryInfoTableView.delegate = self
        categoryInfoTableView.dataSource = self
        DispatchQueue.main.async {
            self.getCategories()
        }
        
        self.hideKeyboard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /* HELPERS */
    func setRightModeImage(textField: UITextField, image: UIImage) {
        imageView.image = image
        textField.rightView = imageView
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    @IBAction func showQuestionsPickerView(_ sender: Any) {
        self.questionPickerView.isHidden = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return questions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return questions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(questions[row])
        selectedQuestion = row
        securityQuestionToggleBtn.titleLabel?.text = questions[row]
        self.questionPickerView.isHidden = true
    }
    
    func getCategories() {
        let request = api.getCategories()
        request.validate()
        request.responseJSON { response in
            if response.error != nil {
                
            }
            else {
                if let jsonValue = response.result.value {
                    let results = JSON(jsonValue)["results"]
                    if results.count > 0 {
                        for item in results.arrayValue {
                            let url = URL(string: self.api.BASE_URL + item["imagepath"].stringValue)
                            let data = try? Data(contentsOf: url!)
                            self.arrayOfCategories.append(categoryInfo(srno: item["srno"].intValue, name: item["name"].stringValue, image: UIImage(data: data!), threadcount: item["thread_count"].intValue, usercount: item["user_count"].intValue))
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func genderChanged(_ sender: Any) {
        if genderSegmentedControl.selectedSegmentIndex == 0 {
            genderSegmentedControl.tintColor = #colorLiteral(red: 0.1058823529, green: 0.631372549, blue: 0.8862745098, alpha: 1)
        }
        else if genderSegmentedControl.selectedSegmentIndex == 1 {
            genderSegmentedControl.tintColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.7058823529, alpha: 1)
        }
    }
    
    func avatarImageTapped(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.image = pickedImage
            
            let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
            avatarImageName = imageURL.lastPathComponent!
            print(avatarImageName)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        /*
            STEP 1 TextFields
        */
        if textField == self.emailTextField || textField == self.aboutYouTextField || textField == self.answerTextField {
            UIView.animate(withDuration: 0.4) {
                self.signUpViewStep1.frame = CGRect(x: self.signUpViewStep1.frame.origin.x, y: -176, width: self.signUpViewStep1.frame.width, height: self.signUpViewStep1.frame.height)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*
            STEP 1 TextFields
         */
        UIView.animate(withDuration: 0.4) {
            self.signUpViewStep1.center = self.view.center
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        /*
            STEP 1 TextFields
         */
        if textField == firstNameTextField {
            if firstNameTextField.returnKeyType == UIReturnKeyType.next {
                lastNameTextField.becomeFirstResponder()
            }
        }
        else if textField == lastNameTextField {
            if lastNameTextField.returnKeyType == UIReturnKeyType.next {
                emailTextField.becomeFirstResponder()
            }
        }
        else if textField == emailTextField {
            if emailTextField.returnKeyType == UIReturnKeyType.next {
                aboutYouTextField.becomeFirstResponder()
            }
        }
        else if textField == aboutYouTextField {
            
        }
        
        return true
    }
    
    func emailTextFieldDidChange(_ textField: UITextField) {
        if textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) != "" {
            textField.rightView?.isHidden = false
            if isValidEmail(email: textField.text!) {
                let request = api.emailExists(email: textField.text!)
                request.validate()
                request.responseJSON { response in
                    if response.error != nil {
                        let error: String = (response.error?.localizedDescription)!
                        self.present(Alert.showErrorAlert(errorMsg: error), animated: true, completion: nil)
                    } else {
                        if let jsonValue = response.result.value {
                            let results = JSON(jsonValue)
                            if results["response"].boolValue {
                                self.setRightModeImage(textField: textField, image: self.incorrectImage)
                                self.emailExistsFlag = true
                            } else {
                                self.setRightModeImage(textField: textField, image: self.correctImage)
                                self.emailExistsFlag = false
                            }
                        }
                    }
                }
            } else {
                self.setRightModeImage(textField: textField, image: self.incorrectImage)
            }
        } else {
            textField.rightView?.isHidden = true
        }
    }
    
    @IBAction func step1NextBtnPressed(_ sender: Any) {
        var errorMsg: String = ""
//        animateSteps(view1: signUpViewStep1, view2: signUpViewStep2)
//        categoryInfoTableView.reloadData()
        if firstNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" || answerTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == "" {
            errorMsg = "Please enter correct credentials"
            self.present(Alert.showErrorAlert(errorMsg: errorMsg), animated: true, completion: nil)
        } else if !isValidEmail(email: emailTextField.text!) {
            errorMsg = "Invalid email"
            self.present(Alert.showErrorAlert(errorMsg: errorMsg), animated: true, completion: nil)
        } else if emailExistsFlag {
            errorMsg = "Email alreadt exists"
            self.present(Alert.showErrorAlert(errorMsg: errorMsg), animated: true, completion: nil)
        } else {
            animateSteps(view1: signUpViewStep1, view2: signUpViewStep2)
            categoryInfoTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "signUpCategoryCell", for: indexPath) as! SignUpCategoryTableViewCell
        
        cell.delegate = self
        cell.tag = indexPath.row
        cell.categoryImageView.clipsToBounds = true
        cell.selectionStyle = .none
        
        if selectedCategories.contains(arrayOfCategories[indexPath.row].srno) {
            cell.selectedCategoryImage.image = #imageLiteral(resourceName: "Ok-50")
        } else {
            cell.selectedCategoryImage.image = nil
        }
        
        cell.categoryImageView.image = arrayOfCategories[indexPath.row].image
        cell.categoryName.text = arrayOfCategories[indexPath.row].name
        
        var threadCountTxt = JSON(arrayOfCategories[indexPath.row].threadcount).stringValue
        if arrayOfCategories[indexPath.row].threadcount == 1 {
            threadCountTxt = threadCountTxt + " Thread"
        } else {
            threadCountTxt = threadCountTxt + " Threads"
        }
        cell.categoryThreadCount.text = threadCountTxt
        
        var userCountTxt = JSON(arrayOfCategories[indexPath.row].usercount).stringValue
        if arrayOfCategories[indexPath.row].usercount == 1 {
            userCountTxt = userCountTxt + " User"
        } else {
            userCountTxt = userCountTxt + " Users"
        }
        cell.categoryUserCount.text = userCountTxt
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear        
    }
    
    func categoryCellDelegate(_ tag: Int, _ cell: SignUpCategoryTableViewCell) {
        
        let indexPath = self.categoryInfoTableView.indexPathForRow(at: cell.center)!
        let selectedItem = arrayOfCategories[indexPath.row].srno
                
        if selectedCategories.contains(selectedItem!) {
            selectedCategories = selectedCategories.filter({ $0 != selectedItem })
        }
        else {
            selectedCategories.append(selectedItem!)
        }
        self.categoryInfoTableView.reloadData()
        print(selectedCategories)
    }
    
    @IBAction func step2BackBtnPressed(_ sender: Any) {
        animateSteps(view1: signUpViewStep2, view2: signUpViewStep1)
    }
    
    @IBAction func step2DoneBtnPressed(_ sender: Any) {
        if selectedCategories.count == 0 {
            self.present(Alert.showErrorAlert(errorMsg: "Select one category atleast"), animated: true, completion: nil)
        } else {
            let csv: String = selectedCategories.description
            print(csv)
            
            var gender = ""
            if genderSegmentedControl.selectedSegmentIndex == 0 {
                gender = "m"
            } else {
                gender = "f"
            }
            
            saveExtendedInfo(fname: firstNameTextField.text!, lname: lastNameTextField.text!, email: emailTextField.text!, gender: gender, about: aboutYouTextField.text!, categories: csv, avatarImage: avatarImageView.image!, avatarImageName: avatarImageName, question: String(selectedQuestion), answer: answerTextField.text!)
        }
    }
    
    public func saveExtendedInfo(fname: String, lname: String, email: String, gender: String, about: String, categories: String, avatarImage: UIImage, avatarImageName: String, question: String, answer: String) {
        
//        let params: [String: Any] = ["fname": fname, "lname": lname, "email": email, "gender": gender, "about": about, "categories": categories, "question": question, "answer": answer]
        
        step2DoneBtn.isHidden = true
        saveInfoIndicator.isHidden = false
        saveInfoIndicator.startAnimating()
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(avatarImage, 1)!, withName: "file", fileName: avatarImageName, mimeType: "image/jpeg")
            multipartFormData.append(fname.data(using: .utf8)!, withName: "fname")
            multipartFormData.append(lname.data(using: .utf8)!, withName: "lname")
            multipartFormData.append(email.data(using: .utf8)!, withName: "email")
            multipartFormData.append(gender.data(using: .utf8)!, withName: "gender")
            multipartFormData.append(about.data(using: .utf8)!, withName: "about")
            multipartFormData.append(categories.data(using: .utf8)!, withName: "categories")
            multipartFormData.append(question.data(using: .utf8)!, withName: "question")
            multipartFormData.append(answer.data(using: .utf8)!, withName: "answer")

        }, to: api.BASE_URL + "Signup/saveExtendedInfo")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                print("inside success")
                
                upload.responseJSON { response in
                    if let jsonValue = response.result.value {
                        let results = JSON(jsonValue)
                        
                        let userdata: String = "\(results["userid"])|\(results["fname"])|\(results["lname"])|\(results["username"])|\(results["avatarpath"])"
                        
                        if KeyClip.save("soapbox.userdata", string: userdata) {
                            let userinfo = KeyClip.load("soapbox.userdata") as String?
                            print(userinfo!)
                            
                            let url = URL(string: self.api.BASE_URL + "userdata/\(results["userid"])/\(results["avatarpath"])")
                            let data = try? Data(contentsOf: url!)
                            let avatarImage = UIImage(data: data!)
                            
                            self.api.saveImageDocumentDirectory(image: avatarImage!)
                            
                            self.saveInfoIndicator.stopAnimating()
                            self.performSegue(withIdentifier: "toTabViewFromSignUp", sender: nil)
                        }
                        else {
                            self.present(Alert.showErrorAlert(errorMsg: "Error saving in keychain"), animated: true, completion: nil)
                        }
                    }
                }
                break
            default: print("default")
                break
            }
        }
    }
    
    
    func animateSteps(view1: UIView, view2: UIView) {
        view1.removeFromSuperview()
        self.view.addSubview(view2)
        view2.center = self.view.center
    }
    
}
