//
//  RegistrationViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 07/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit
import Validator
import SwiftOverlays

class RegistrationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    
    
    @IBOutlet weak var labelErrorFirstName: UILabel!
    @IBOutlet weak var labelErrorLastName: UILabel!
    @IBOutlet weak var labelErrorEmail: UILabel!
    @IBOutlet weak var labelErrorPhoneNumber: UILabel!
    
    
    let user = User()
    
    var completionHandler: ((Void) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        textFieldFirstName.setBottomBorder()
//        textFieldEmail.setBottomBorder()
//        textFieldLastName.setBottomBorder()
//        textFieldPhoneNumber.setBottomBorder()
        
        bindData()
        
    }
    
    
    
    func bindData(){
        
        user.firstName.bidirectionalBind(to: textFieldFirstName.reactive.text)
        user.lastName.bidirectionalBind(to: textFieldLastName.reactive.text)
        user.email.bidirectionalBind(to: textFieldEmail.reactive.text)
        user.phone.bidirectionalBind(to: textFieldPhoneNumber.reactive.text)
    }
    
    func validateInput() -> Bool {
        
        var status: Bool = true
        
        //First name
        let minimnumLengthRule = ValidationRuleLength(min: 1, error: ValidationError(message: "Required"))
        
        var nameRules = ValidationRuleSet<String>()
        nameRules.add(rule: minimnumLengthRule)
        
        
        let firstNameResult = textFieldFirstName.validate(rules: nameRules)
        
        
        //Last Name
        let lastNameResult = textFieldLastName.validate(rules: nameRules)
        
        //Email
        let emailRule = ValidationRulePattern(pattern: EmailValidationPattern.standard, error: ValidationError(message: "Invalid email"))
        var emailRules = ValidationRuleSet<String>()
        
        emailRules.add(rule: minimnumLengthRule)
        emailRules.add(rule: emailRule)
        
        let emailResult = textFieldEmail.validate(rules: emailRules)
        
        //Phone number
//        let phoneRule = ValidationRulePattern(pattern: "^\\+?\\s?\\d{3}\\s?\\d{3}\\s?\\d{4}$", error: ValidationError(message: "Enter valid phone"))
//        
//        var phoneRules = ValidationRuleSet<String>()
//        
//        phoneRules.add(rule: phoneRule)
//        
//        let phoneResult = textFieldPhoneNumber.validate(rules: phoneRules)
        
        /////
        var tempStatus = validationDisplay(result: firstNameResult, label: labelErrorFirstName)
        status = status && tempStatus
        
        tempStatus = validationDisplay(result: lastNameResult, label: labelErrorLastName)
        status = status && tempStatus
        
        tempStatus = validationDisplay(result: emailResult, label: labelErrorEmail)
        status = status && tempStatus
        
//        tempStatus = validationDisplay(result: phoneResult, label: labelErrorPhoneNumber)
//        status = status && tempStatus
        
        return status
    }
    
    func validationDisplay(result: ValidationResult, label: UILabel) -> Bool
    {
        var status = false
        
        switch result {
        case .valid:
            label.isHidden = true
            status = true
        case .invalid(let failures):
            let messages = failures.flatMap { $0 as? ValidationError }.map { $0.message }
            label.text = messages.joined(separator: ", ")
            label.isHidden = false
        }
        
        return status
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    @IBAction func buttonRegistrationPressed(_ sender: Any) {
        
        let validationStatus = validateInput()
        
        if validationStatus {
            
//            SwiftOverlays.showBlockingWaitOverlay()
            
            let apiService = APIService()
            
            apiService.callServiceRegister(user: self.user, completion: { (status, message) in
                
//                SwiftOverlays.removeAllBlockingOverlays()
                
                if status == 0 {
                    UserDefaults.standard.set("1", forKey: "Registered")
                    
                    let alert = UIAlertController(title: "Registration", message: "Registered sucessfully", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                        
                        self.dismiss(animated: false, completion: {
                            if ( self.completionHandler != nil) {
                                self.completionHandler!()
                            }
                        })
                    })
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion: nil)
        
                } else {
                    
                    let alert = UIAlertController(title: "Registration", message: "Registration failure", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(okAction)
                    
                    self.present(alert, animated: true, completion:  nil)
                }
                
            })
        }
    }
    
    //text field handling
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    

}
