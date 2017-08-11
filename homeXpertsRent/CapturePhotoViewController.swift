//
//  CapturePhotoViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 07/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CapturePhotoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    var currentLocationCoordinates = CLLocationCoordinate2D()
    var annotation:  MKPointAnnotation?
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        UserDefaults.standard.removeObject(forKey: "Registered")
        
        if UserDefaults.standard.object(forKey: "Registered") == nil {
            let registrationView = storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
            
            registrationView.completionHandler = initServices
            
            self.present(registrationView, animated: false, completion: nil)
        }
        else{
            
            initServices()
        }
    }
    
    @IBAction func buttonSettingsPressed(_ sender: Any) {
        let settingsView = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        self.present(settingsView, animated: false, completion: nil)
    }
    
    func initServices()->Void{
        
        if LocationService.isLocationServiceEnabled() != true {
            
            let locationView = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
            locationManager.stopUpdatingLocation()
            
            self.present(locationView, animated: false, completion: nil)
            
        } else {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func buttonCapturePressed(_ sender: Any) {
        
        let cameraView = storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        
        cameraView.photoConfirmationHandler = { (image) in
            
            if image != nil {
                
//                print ("Test")
                
                let propertyView = self.storyboard?.instantiateViewController(withIdentifier: "PropertyViewController") as! PropertyViewController
                propertyView.image = image
                propertyView.coordinates = self.currentLocationCoordinates
                
                self.present(propertyView, animated: true, completion: nil)
                
            }
        }
        
        self.present(cameraView, animated: false, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        if LocationService.isLocationServiceEnabled() != true {
            
            let locationView = storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as! LocationViewController
            locationManager.stopUpdatingLocation()
            
            self.present(locationView, animated: false, completion: nil)
            
            
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation: CLLocation = locations[0]
        self.currentLocationCoordinates = userLocation.coordinate
        
        if annotation == nil {
            annotation = MKPointAnnotation()
            
            mapView.addAnnotation(annotation!)
        }
        
        if let annotat = annotation{
        
            let latitude = userLocation.coordinate.latitude
            let longitude = userLocation.coordinate.longitude
            let lanDelta: CLLocationDegrees = 0.05
            let lonDelta: CLLocationDegrees = 0.05
            
            let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
            
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            let region = MKCoordinateRegion(center: coordinates, span: span)
            
            mapView.setRegion(region, animated: true)
            
            annotat.title = "You are here"
        
            annotat.coordinate = userLocation.coordinate
        
        }
        
//        let latitude = userLocation.coordinate.latitude
//        
//        let longitude = userLocation.coordinate.longitude
//        
//        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
//        CLGeocoder().reverseGeocodeLocation(userLocation){ (placemarks, error) in
//            
//            if  error != nil {
//                print(error)
//            } else {
//                if let placemark = placemarks?[0]{
//                    print(placemark)
//                }
//            }
//
//        }
    }

}
