//
//  PickerViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 06/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var completionHandler: ((Void) -> Void)?
    
    var selectedItem : PickerKeyValue?
    var inputList = [PickerKeyValue]()
    
    @IBOutlet weak var mPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        // Do any additional setup after loading the view.
        
        //select Item
        if let selected = selectedItem {
            
            let selectedIndex = inputList.index{ $0 === selected}
            
            if  let indexPos = selectedIndex {
                mPicker.selectRow(indexPos, inComponent: 0, animated: false)
            }
            else {
                selectedItem = nil
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return (inputList.count)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        selectedItem = inputList[row]
        
        if let completionHandler = completionHandler{
            dismiss(animated: true, completion: completionHandler)
        }
        else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return inputList[row].text
    }
    

}
