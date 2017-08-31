//
//  PropertyViewController.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 04/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit
import MapKit
import ReactiveKit
import Bond
import SwiftOverlays
import GoogleMaps

class PropertyViewController: UIViewController, MKMapViewDelegate, UIScrollViewDelegate {
    
    // Properties
    var propertyInfo = PropertyInfo()
    var image: UIImage!
    var coordinates = CLLocationCoordinate2D()
    
    var camera: GMSCameraPosition?
    var mapMarker: GMSMarker?
    
    // Outlets
    
    @IBOutlet weak var mapViewer: GMSMapView!
    @IBOutlet weak var labelSurfaceLiving: UILabel!
    @IBOutlet weak var labelRoomNumber: UILabel!
    @IBOutlet weak var labelYear: UILabel!
    @IBOutlet weak var labelPropertyType: UILabel!
    @IBOutlet weak var labelLift: UILabel!
    
    @IBOutlet weak var sliderSurfaceLiving: UISlider!
    @IBOutlet weak var sliderRoomNumber: UISlider!
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var buttonEstimate: UIButton!
    
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelAppraisalValue: UILabel!
    @IBOutlet weak var segmentedPropertyCategory: UISegmentedControl!
    
    
    @IBOutlet weak var viewFloat: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewImageContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        emptyView = EmptyView(frame: CGRect(x: 0, y: viewHeader.frame.origin.y + viewHeader.bounds.height
                                , width: view.bounds.width, height: view.bounds.height - (viewHeader.bounds.height+viewHeader.frame.origin.y )))
        view.addSubview(emptyView)
        view.bringSubview(toFront: emptyView)
        emptyView.alpha = 1
        emptyView.rotate()
        
        buttonEstimate.isEnabled = false
        if image != nil {
            loadData()
            loadFloatingView()
        }
        
        self.view.bringSubview(toFront: viewHeader)
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func buttonSettingsPressed(_ sender: Any) {
        let settingsView = storyboard?.instantiateViewController(withIdentifier: "SettingsContainerViewController") as! SettingsContainerViewController
        
        self.present(settingsView, animated: false, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        
//        print("\(scrollView.contentOffset.y)")
        
        let curScrollY = scrollView.contentOffset.y
        
        if curScrollY > viewImageContainer.frame.size.height {
            viewFloat.isHidden = false
        } else {
            viewFloat.isHidden = true
        }
    }
    
    func loadFloatingView() {
        
        
        let floatingView = storyboard?.instantiateViewController(withIdentifier: "FloatViewController") as! FloatViewController
        
        floatingView.propertyInfo = propertyInfo
        floatingView.view.frame = viewFloat.bounds
        
        viewFloat.addSubview(floatingView.view)
        addChildViewController(floatingView)
        floatingView.didMove(toParentViewController: self)
    }
    
    var emptyView = EmptyView()
    
    func loadData()
    {
//        SwiftOverlays.showBlockingWaitOverlay()
        
        
        
        
        bindData()
        
        setMapView()
        
        let apiService = APIService();
        
        apiService.callOfferedRentDefaultService(propertyData: propertyInfo) { (status) in
            
            
//            SwiftOverlays.removeAllBlockingOverlays()
            self.emptyView.stopRotating()
            if status == 0 {
                
                if self.propertyInfo.catCode.value == -1 {
                    let msg = "Looks like your picture is not proper Real estate property picture. \n\nOur image processing tools says picture looks like of \"\(self.propertyInfo.category.value)\" \n\nPlease click proper picture and valuate again"
                    
                    self.emptyView.showMessage(message: msg)
                }
                else {
                    self.buttonEstimate.isEnabled = true
                    self.emptyView.alpha = 0
                }
                
            } else {
                
                self.emptyView.showMessage(message: "Service error")
//                let alert = UIAlertController(title: "Property view", message: "Service error", preferredStyle: .alert)
//                
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//                    
//                    self.dismiss(animated: false, completion: {
//                       
//                    })
//                })
//                
//                alert.addAction(okAction)
//                
//                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func estimate()
    {
        SwiftOverlays.showBlockingWaitOverlay()
        
        
        let apiService = APIService();
        
        apiService.callOfferedRentService(propertyData: propertyInfo) { (status) in
            
            SwiftOverlays.removeAllBlockingOverlays()
            
            if status == 0 {
//                print("Enabled")
                self.buttonEstimate.isEnabled = true
            } else {
                
                let alert = UIAlertController(title: "Property view", message: "Service error", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    
                })
                
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage! {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func bindData()
    {
        propertyInfo = PropertyInfo()
        
        if let newImage = resizeImage(image: image, newWidth: 300){
            
            imageView.image = newImage
            
            if let imageData = UIImageJPEGRepresentation(newImage, 1.0) {
                let base64Image = imageData.base64EncodedString()
                
                propertyInfo.imageBase64String = base64Image
                //                print(base64Image.characters.count)
                
                //            propertyInfo.imageBase64 = base64Image as NSData
            }
        }
        
//        propertyInfo.imageBase64String = image.getBase64()
        
        imageView.image = image
        
        //address
        combineLatest(propertyInfo.street, propertyInfo.zip, propertyInfo.town){ street, zip, town in
            return "\(street), \(zip) \(town)"
            }
            .bind(to: labelAddress)
        
        // appraised value
        propertyInfo.appraisalValue.map{
            "\(Int($0)) CHF"
        }.bind(to: labelAppraisalValue)
        
        //Surface Contract
        propertyInfo.surfaceContract.map{ round($0/1)/1}.bind(to: sliderSurfaceLiving)
        sliderSurfaceLiving.reactive.value.map{round($0/1)/1}.bind(to: propertyInfo.surfaceContract)
        propertyInfo.surfaceContract.map{ $0.roundedValueToString }.bind(to: labelSurfaceLiving)
        
        // Room number
        propertyInfo.roomNb.map{ round($0/0.5)*0.5}.bind(to: sliderRoomNumber)
        sliderRoomNumber.reactive.value.map{ round($0/0.5)*0.5}.bind(to: propertyInfo.roomNb)
        propertyInfo.roomNb.map{ "\($0)" }.bind(to: labelRoomNumber)
        
        // Build year
        propertyInfo.buildYear.map{ "\($0)" }.bind(to: labelYear)
        
        // Property type
        propertyInfo.propertyTypeCodeText.bind(to: labelPropertyType)
        
        // Lift
        propertyInfo.liftText.bind(to: labelLift)
        
        //coordinates
        propertyInfo.latitude.next(coordinates.latitude as Double)
        propertyInfo.longitude.next(coordinates.longitude as Double)
        
//        print(propertyInfo.latitude.value)
//        print(propertyInfo.longitude.value)
        
        // propertyCategory
        propertyInfo.catCode.map{
            switch $0 {
            case 5:
                return 0
            case 6:
                return 1
            default:
                return 0
            }
            }.bind(to: segmentedPropertyCategory.reactive.selectedSegmentIndex)
        segmentedPropertyCategory.reactive.selectedSegmentIndex.map{
            switch $0 {
            case 0:
                return 5
            case 1:
                return 6
            default:
                return 0
            }
        }.bind(to: propertyInfo.catCode)
    }

    func setMapView()
    {
//        let annotation = MKPointAnnotation()
//            
//        mapView.addAnnotation(annotation)
//        
//        let latitude = self.coordinates.latitude
//        let longitude = self.coordinates.longitude
//        let lanDelta: CLLocationDegrees = 0.05
//        let lonDelta: CLLocationDegrees = 0.05
//            
//        let span = MKCoordinateSpan(latitudeDelta: lanDelta, longitudeDelta: lonDelta)
//            
//        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            
//        let region = MKCoordinateRegion(center: coordinates, span: span)
//            
//        mapView.setRegion(region, animated: true)
//            
//        annotation.title = "You are here"
//            
//        annotation.coordinate = coordinates
//        
//        let userLocation: CLLocation = locations[0]
//        self.currentLocationCoordinates = userLocation.coordinate
        
        
        if camera == nil {
            camera = GMSCameraPosition.camera(withTarget: coordinates, zoom: 14.0)
            
            mapViewer.moveCamera(GMSCameraUpdate.setCamera(camera!))
        }
        
        if mapMarker == nil {
            mapMarker = GMSMarker()
            
            mapMarker!.map = mapViewer
            mapMarker!.title = "You are here"
        }
        
        if let marker = mapMarker {
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)
            marker.position = coordinates
            CATransaction.commit()
            
        }
    }
    
    
    @IBAction func buttonShowPropertyTypePressed(_ sender: Any) {
        
        let pickerView = storyboard?.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        
        pickerView.modalTransitionStyle = .coverVertical
        pickerView.modalPresentationStyle = .overCurrentContext
        
        //
        pickerView.inputList = [PickerKeyValue]()
        pickerView.inputList.append(PickerKeyValue(key: "21", text: "Normal Flat"))
        pickerView.inputList.append(PickerKeyValue(key: "15", text: "Furnished Aparment"))
        pickerView.inputList.append(PickerKeyValue(key: "13", text: "Duplex"))
        pickerView.inputList.append(PickerKeyValue(key: "1099", text: "Terrace Apartment"))
        pickerView.inputList.append(PickerKeyValue(key: "2", text: "Penthouse"))
        pickerView.inputList.append(PickerKeyValue(key: "5", text: "Attic"))
        pickerView.inputList.append(PickerKeyValue(key: "16", text: "Studio"))
        pickerView.inputList.append(PickerKeyValue(key: "100", text: "Loft"))
        pickerView.inputList.append(PickerKeyValue(key: "1199", text: "House"))
        
        let selectedText = String(propertyInfo.propertyTypeCode.value)
        let selectedIndex = pickerView.inputList.index{ $0.key == selectedText}
        
        if  let indexPos = selectedIndex {
            pickerView.selectedItem = pickerView.inputList[indexPos]
        }
        
        
        let completionHandler : ()->Void = {
            if let selectedItem = pickerView.selectedItem
            {
                self.propertyInfo.propertyTypeCode.next(Int(selectedItem.key)!)
                self.propertyInfo.propertyTypeCodeText.next(selectedItem.text)
            }
        }
        
        pickerView.completionHandler = completionHandler
        
        present(pickerView, animated: true, completion: nil)
        
    }
    
    
    @IBAction func buttonShowLiftPressed(_ sender: Any) {
        
        let pickerView = storyboard?.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        
        pickerView.modalTransitionStyle = .coverVertical
        pickerView.modalPresentationStyle = .overCurrentContext
        
        //
        pickerView.inputList = [PickerKeyValue]()
        pickerView.inputList.append(PickerKeyValue(key: "0", text: "No"))
        pickerView.inputList.append(PickerKeyValue(key: "1", text: "Yes"))
        
        let selectedText = String(propertyInfo.lift.value)
        let selectedIndex = pickerView.inputList.index{ $0.key == selectedText}
        
        if  let indexPos = selectedIndex {
            pickerView.selectedItem = pickerView.inputList[indexPos]
        }
        
        let completionHandler : ()->Void = {
            if let selected = pickerView.selectedItem
            {
                self.propertyInfo.lift.next(Int(selected.key)!)
                self.propertyInfo.liftText.next(selected.text)
            }
        }
        
        pickerView.completionHandler = completionHandler
        
        present(pickerView, animated: true, completion: nil)
        
    }
    
    @IBAction func buttonShowYearPickerPressed(_ sender: Any) {
        
        let pickerView = storyboard?.instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController

        pickerView.modalTransitionStyle = .coverVertical
        pickerView.modalPresentationStyle = .overCurrentContext
        
        //
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        
        let yearRange = (year + 2)

        pickerView.inputList = (1900...yearRange).map{ PickerKeyValue(key: "\($0)", text: "\($0)" ) }
        
        let selectedText = String(propertyInfo.buildYear.value)
        let selectedIndex = pickerView.inputList.index{ $0.key == selectedText}
        
        if  let indexPos = selectedIndex {
            pickerView.selectedItem = pickerView.inputList[indexPos]
        }
        
        let completionHandler : ()->Void = {
            if let selected = pickerView.selectedItem
            {
                self.propertyInfo.buildYear.next(Int(selected.key)!)
            }
        }
        
        pickerView.completionHandler = completionHandler
        
        present(pickerView, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func buttonEstimatePressed(_ sender: Any) {
        print("Clicked")
        estimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
}

extension Float{
    var roundedValueToString: String{
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
