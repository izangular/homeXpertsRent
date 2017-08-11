//
//  ConfirmPhotoViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 08/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit

class ConfirmPhotoViewController: UIViewController {

    var image: UIImage!
    
    var photoConfirmationHandler: ((Bool) -> Void)?

    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        loadImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loadImage(){
        
        if let image = image {
            imageView!.image = image
        }
    }
    
    @IBAction func confirmPressed(_ sender: Any) {
        
        self.dismiss(animated: false, completion: {
            
            if self.photoConfirmationHandler != nil {
                self.photoConfirmationHandler!(true)
            }
        })
    }
    
    @IBAction func backPressed(_ sender: Any) {
        
        self.dismiss(animated: false, completion: {
            
            if ( self.photoConfirmationHandler != nil ){
                self.photoConfirmationHandler!(false)
            }
        })
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
