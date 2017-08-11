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
//        bottomLine.frame = CGRect(0.0, self.frame.height - 1, self.frame.width, 1.0)
        bottomLine.frame = CGRect(x: 0.0, y: self.frame.height-1, width: self.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        self.borderStyle = UITextBorderStyle.none
        self.layer.addSublayer(bottomLine)
        
//        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
//        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
//        
//        let path = UIBezierPath()
//        
//        path.move(to: startingPoint)
//        path.addLine(to: endingPoint)
//        path.lineWidth = 2.0
//        
//        tintColor.setStroke()
//        
//        path.stroke()
    }
}
