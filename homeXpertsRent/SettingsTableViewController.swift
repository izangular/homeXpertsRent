//
//  TableViewController.swift
//  homeXpertsRent
//
//  Created by IIT Web Dev on 14/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonLanguagePressed(_ sender: Any) {
        
        let pickerView = storyboard?.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        
        pickerView.modalTransitionStyle = .coverVertical
        pickerView.modalPresentationStyle = .overCurrentContext
        
        //
        pickerView.inputList = [PickerKeyValue]()
        pickerView.inputList.append(PickerKeyValue(key: "en", text: "English"))
        pickerView.inputList.append(PickerKeyValue(key: "de", text: "German"))
        
        if let lang = Locale.current.languageCode {
            
            let selectedIndex = pickerView.inputList.index{ $0.key == lang}
            
            if  let indexPos = selectedIndex {
                pickerView.selectedItem = pickerView.inputList[indexPos]
            }
        }
        
        
        let completionHandler : ()->Void = {
            if let selectedItem = pickerView.selectedItem
            {
                let lang = selectedItem.key
//                print(Locale.current.languageCode!)
                
                UserDefaults.standard.set([lang],  forKey: "AppleLanguages")
//                print(lang)
                UserDefaults.standard.synchronize()
//                print(Locale.current.languageCode!)
                
            }
        }
        
        pickerView.completionHandler = completionHandler
        
        present(pickerView, animated: true, completion: nil)
    }
    
    
    @IBAction func buttonContactPressed(_ sender: Any) {
        print("Contact")
    }

    @IBAction func buttonPrivacyPressed(_ sender: Any) {
        print("Privacy")
    }
    
    
    @IBAction func buttonTermsPressed(_ sender: Any) {
        print("Terms")
    }
}
