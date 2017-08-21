//
//  TextField.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 10/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit

class TextField : UITextField {
    
    override var tintColor: UIColor! {
        
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height-1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = UITextBorderStyle.none
        self.layer.addSublayer(bottomLine)
        
//        let borderBottom = CALayer()
//        let borderWidth = CGFloat(2.0)
//        borderBottom.borderColor = UIColor.white.cgColor
//        borderBottom.frame = CGRect(x: 0, y: self.frame.height - 1.0, width: self.frame.width, height: self.frame.height - 1.0)
//        borderBottom.borderWidth = borderWidth
//        self.layer.addSublayer(borderBottom)
//        self.layer.masksToBounds = true
        
    }
}
