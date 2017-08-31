//
//  LocationViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 07/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("IN")
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if ( status == .authorizedAlways || status == .authorizedWhenInUse )
        {
            locationManager.startUpdatingLocation()
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

    @IBAction func buttonEnableServicePressed(_ sender: Any) {
        
//        let authStatus = CLLocationManager.authorizationStatus()
//        
//        if authStatus == .notDetermined || authStatus == .denied {
//            if let url = URL(string: UIApplicationOpenSettingsURLString){
//                UIApplication.shared.openURL(url)
//            }
//        }
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
    
    @IBAction func buttonDonotallowPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Location service Disabled", message: "Please enable Location Service in settings", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion:  nil)
        
        return
    }
    
}
