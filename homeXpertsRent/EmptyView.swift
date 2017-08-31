//
//  EmptyDialog.swift
//  rentXperts
//
//  Created by IIT Web Dev on 31/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var imageViewCenter: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabelCenter: NSLayoutConstraint!
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("EmptyView", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func showMessage(message: String){
        imageView.alpha = 0
        messageLabel.text = message
        self.imageView.alpha = 0
        self.imageViewCenter.priority = 1
        self.titleLabelCenter.priority = 999
        self.contentView.layoutIfNeeded()
    }
    
    func rotate() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnimation.fromValue = 0.0
        rotationAnimation.toValue = 2*Double.pi
        rotationAnimation.duration = 1
        rotationAnimation.repeatCount = Float.infinity
        rotationAnimation.isRemovedOnCompletion = false
        self.imageView.layer.add(rotationAnimation, forKey: "rotate")
    }
    
    func stopRotating() {
        self.imageView.layer.removeAllAnimations()
    }
}
