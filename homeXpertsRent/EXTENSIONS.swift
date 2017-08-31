//
//  EXTENSIONS.swift
//  rentXperts
//
//  Created by IIT Web Dev on 31/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit


extension UIImage {
    func getBase64() -> String? {
        if let imageData = UIImageJPEGRepresentation(self, 0.5) {
            let base64String = imageData.base64EncodedString()
            
            return base64String
        } else {
            return nil
        }
    }
}
