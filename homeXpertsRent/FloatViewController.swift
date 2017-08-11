//
//  FloatViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 10/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit
import Bond
import ReactiveKit

class FloatViewController: UIViewController, UIScrollViewDelegate {

    var propertyInfo : PropertyInfo?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelAppraisalValue: UILabel!
    @IBOutlet weak var labelSurface: UILabel!
    @IBOutlet weak var labelRoom: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setBindings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setBindings()
    {
        
        if let property = propertyInfo {
            
            property.surfaceContract.map{
                "\($0)"
            }.bind(to: labelSurface)
            
            property.roomNb.map{
                "\($0)"
            }.bind(to: labelRoom)
            
            property.appraisalValue.map{
                "\($0)"
            }.bind(to: labelAppraisalValue)
            
            let dataDecoded: NSData = NSData(base64Encoded: property.imageBase64String!, options:.ignoreUnknownCharacters)!
            let image : UIImage = UIImage(data: dataDecoded as Data)!
            
            imageView.image = image
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
