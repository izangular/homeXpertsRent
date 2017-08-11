//
//  ViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 23/07/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit

import AVFoundation
import MobileCoreServices
import CoreLocation
import Alamofire


class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    var locationManager = CLLocationManager()
    
    var imagePicker: UIImagePickerController?
    var propertyData : PropertyData!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //
        getLocation()
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        if  UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func getLocation(){
//        guard CLLocationManager.locationServicesEnabled() else{
//            print("Location service is not enabled on your device. Please enable.")
//            return
//        }
//        
//        let authStatus = CLLocationManager.authorizationStatus()
//        guard authStatus == .authorizedWhenInUse else {
//            switch authStatus{
//            case .denied, .restricted:
//                print("App not authorised to use your location")
//                
//            case .notDetermined:
//                locationManager.requestWhenInUseAuthorization()
//                
//            default:
//                print("Something went wrong!!")
//            }
//            return
//        }
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if  CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
//        self.locationManager.delegate = self
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.startUpdatingLocation()
//        print("Location working")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
//        let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
//        propertyData.latitude = locValue.latitude
//        propertyData.longitude = locValue.longitude
        
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Error: \(error)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "capturePropertyView"{
            
            let capturePropertyViewController = segue.destination as! CapturePropertyViewController
            
            capturePropertyViewController.propertyData = propertyData
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        
        if (mediaType.isEqual(to: kUTTypeImage as String)){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            propertyData = PropertyData()
            propertyData.image = encodeImageToBase64(image: image)
            propertyData.latitude = locationManager.location?.coordinate.latitude
            propertyData.longitude = locationManager.location?.coordinate.longitude
            setDataParameters()
            callService()
            
            self.performSegue(withIdentifier: "capturePropertyView", sender: self)
        }
    }
    
    func setDataParameters(){
        propertyData.street = "Tramstrasse 10"
        propertyData.zip = "8050"
        propertyData.town = "Zurich"
        
        propertyData.microRating = 2.0
        propertyData.propertyType = "House"
        propertyData.price = 2000300
        propertyData.bathNb = 2
        propertyData.buildYear = 1990
        propertyData.microRating = 5
        propertyData.renovationYear = 0
        propertyData.roomNb = 2.5
        propertyData.surfaceLiving = 120
    }
    
    
    
    func callService(){
        
        
        let url = URL(string: "https://devweb.iazi.ch/Service.Report_2407/api/Image/ImageProcessing")!
        
        var request = URLRequest(url: url)
    
        
//        request.httpMethod = "POST"
//        let postString = "imageBase64=\(propertyData.image!)&latitude=\(propertyData.latitude!)&longitude=\(propertyData.longitude!)"
//        let postString = "imageBase64=uy&latitude=47.409123&longitude=8.546728"
//        request.httpBody = postString.data(using: .utf8)
//        request.timeoutInterval = 5000
        let json: [String: Any] = ["imageBase64": "", "latitude": "47.409123", "longitude": "8.546728"]
        var jsonData : Data
        do{
            jsonData = try JSONSerialization.data(withJSONObject: json)
            request.httpBody = jsonData
        } catch {
            print("JSON serialization Failed")
        }
        
        request.setValue("Content-Type", forHTTPHeaderField: "application/x-www-form-urlencoded")
        
//        request.setValue("imageBase64", forKey: "")
//        request.setValue("latitude", forKey: "47.409123")
//        request.setValue("longitude", forKey: "8.546728")
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
            
            if error != nil {
                print(error!)
            } else {
                if  let urlContent = data {
                    
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        print(jsonResult)
//                        print(jsonResult["appraisedValue"])
                        if let dictionary = jsonResult as? [String: AnyObject]{
                            if let appraisalValue = dictionary["appraisalValue"] as? Int{
                                self.propertyData.price = appraisalValue
                            }
                            
                            if let category = dictionary["category"] as? String{
                                self.propertyData.propertyType = category
                            }
                            
//                            if let country = dictionary["country"] as? String{
//                                self.propertyData.propertyType = category
//                            }
                            
                            if let rating = dictionary["rating"] as? Float{
                                self.propertyData.microRating = rating
                            }
                            
                            if let street = dictionary["street"] as? String{
                                self.propertyData.street = street
                            }
                            
                            if let town = dictionary["town"] as? String{
                                self.propertyData.town = town
                            }
                            
                            if let zip = dictionary["zip"] as? String{
                                self.propertyData.zip   = zip
                            }
                        }
                        
                        
                    } catch {
                        print("JSON Processing Failed")
                    }
                    
                    
                }
            }
        }
        task.resume()
    }
    
    func encodeImageToBase64(image: UIImage) -> String{
        let imageData: NSData = UIImageJPEGRepresentation(image, 1)! as NSData
        
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        
        return strBase64
    }
    
    func decodeBase64ToImage(base64: String) -> UIImage{
        
        let dataDecoded: NSData = NSData(base64Encoded: base64, options:.ignoreUnknownCharacters)!
        let decodedImage : UIImage = UIImage(data: dataDecoded as Data)!
        
        return decodedImage
        
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer){
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
//        image.withHorizontallyFlippedOrientation()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController, didFinsishPickingMediaWithIfo info: [String: AnyObject]) {
        self.dismiss(animated: true, completion: nil)
        
        
    }
}

