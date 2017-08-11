//
//  PropertyInfo.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 08/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond

class PropertyInfo{
    var authToken: String = ""
    var authStatus: Int = -1
    
    //Binding
    var imageBase64: NSData?
    var imageBase64PngString: String?
    var imageBase64String: String?
    let latitude = Observable<Double>(0)
    let longitude = Observable<Double>(0)
    
    let appraisalValue = Observable<Float>(0)
    let rating = Observable<Float>(0)
    
    let street = Observable<String>("")
    let zip = Observable<String>("")
    let town = Observable<String>("")
    let country = Observable<String>("")
    let ortId = Observable<Int>(0)
    
    let category = Observable<String>("")
    let catCode = Observable<Int>(0)
    
    var surfaceContract = Observable<Float>(0)
    var roomNb = Observable<Float>(0)
    var buildYear = Observable<Int>(0)
    
    let propertyTypeCode = Observable<Int>(0)
    let propertyTypeCodeText = Observable<String>("")
    
    let lift = Observable<Int>(0)
    let liftText = Observable<String>("")
    
    
    init() {
        
        
        
//        _ = surfaceLiving.observeNext(with: { (value) in print(self.surfaceLiving.value) })
//        _ = roomNb.observeNext(with: { (value) in print(self.roomNb.value) })
        
        surfaceContract.next(50)
        roomNb.next(1)
        buildYear.next(1950)
        propertyTypeCode.next(21)
        propertyTypeCodeText.next("Normal Flat")
        lift.next(0)
        liftText.next("No")
        
        street.next("")
        zip.next("")
        town.next("")
        appraisalValue.next(0)
        rating.next(0)
        country.next("")
        category.next("")
        catCode.next(0)
        
        
        latitude.next(47.408934)
        longitude.next(8.547593)
        
        authToken = ""
        authStatus = -1
    }
    
}
