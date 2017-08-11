//
//  PickerKeyValue.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 09/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit

class PickerKeyValue {
    
    var key: String = ""
    var text: String = ""
    
    convenience init(key: String, text: String){
        self.init()
        
        self.key = key
        self.text = text
    }

}
