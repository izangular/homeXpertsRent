//
//  PropertyData.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 24/07/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//


import Bond
import Foundation
import ReactiveKit

class PropertyData {
    var authToken: String = ""
    var authStatus: Int = -1
    
    //Binding
    let imageBase64 = PublishSubject1<String>()
    let latitude = PublishSubject1<Double>()
    let longitude = PublishSubject1<Double>()
    
    let appraisalValue = PublishSubject1<Float>()
    let rating = PublishSubject1<Float>()
    let street = PublishSubject1<String>()
    let zip = PublishSubject1<String?>()
    let town = PublishSubject1<String?>()
    let country = PublishSubject1<String?>()
    let category = PublishSubject1<String?>()
    let catCode = PublishSubject1<Int?>()
    
    var surfaceLiving = PublishSubject1<Float>()
    var landSurface = PublishSubject1<Float>()
    var roomNb = PublishSubject1<Float>()
    var bathNb = PublishSubject1<Float>()
    var buildYear = PublishSubject1<Float>()
    
    //Value
    var vSurfaceLiving: Float = 0
    var vLandSurface: Float = 0
    var vRoomNb: Float = 0
    var vBathNb: Float = 0
    var vBuildYear: Float = 0
    
    var vImageBase64: String = ""
    var vLatitude: Double = 0
    var vLongitude: Double = 0
    
    var vAppraisalValue: Float = 0
    var vRating: Float = 0
    var vStreet: String = ""
    var vZip: String = ""
    var vTown: String = ""
    var vCountry: String = ""
    var vCategory: String = ""
    var vCatCode: Int = 0
    
    init() {
        
        _ = surfaceLiving.observeNext(with: { (value) in self.vSurfaceLiving = value })
        _ = landSurface.observeNext(with: { (value) in self.vLandSurface = value })
        _ = roomNb.observeNext(with: { (value) in self.vRoomNb = value })
        _ = bathNb.observeNext(with: { (value) in self.vBathNb = value })
        _ = buildYear.observeNext(with: { (value) in self.vBuildYear = value })
        _ = imageBase64.observeNext(with: { (value) in self.vImageBase64 = value })
        _ = latitude.observeNext(with: { (value) in self.vLatitude = value })
        _ = longitude.observeNext(with: { (value) in self.vLongitude = value })
        _ = appraisalValue.observeNext(with: { (value) in self.vAppraisalValue = value })
        _ = rating.observeNext(with: { (value) in self.vRating = value })
        _ = street.observeNext(with: { (value) in self.vStreet = value })
        _ = zip.observeNext(with: { (value) in self.vZip = value! })
        _ = town.observeNext(with: { (value) in self.vTown = value! })
        _ = country.observeNext(with: { (value) in self.vCountry = value! })
        _ = category.observeNext(with: { (value) in self.vCategory = value! })
        _ = catCode.observeNext(with: { (value) in self.vCatCode = value! })
        
        surfaceLiving.next(50)
        landSurface.next(200)
        roomNb.next(2)
        bathNb.next(1)
        buildYear.next(1950)
        
        street.next("")
        zip.next("")
        town.next("")
        appraisalValue.next(0)
        rating.next(0)
        country.next("")
        category.next("")
        catCode.next(0)
        
        imageBase64.next("base")
        latitude.next(47.408934)
        longitude.next(8.547593)
        
        authToken = ""
        authStatus = -1
    }

}
