//
//  API.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 01/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//


import Alamofire


class APIService {
    
    let authUser: String = "appservice@iazi.ch"
    let authPassword: String = "LetsT3st"
    let intUrl: String = "https://intservices.iazi.ch/api"
    let authSubUrl: String = "/auth/v2/login"
    let appSubImageProcessingUrl: String = "/apps/ImageProcessing"
    let appSubAppraisePropertyUrl: String = "/apps/AppraiseProperty"

    
    func callServiceRegister(user: User, completion: @escaping (_ status: Int, _ statusMessage: String) -> ())
    {
        var statStatusCode = -1
        var statStatusMessage = "Error: Unknown"
        
        let url = URL(string: intUrl + "/apps/v1/register")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        
        let params: Parameters = ["firstName": user.firstName.value!,
                                  "lastName": user.lastName.value!,
                                  "email": user.email.value!,
                                  "phone": user.phone.value!,
                                  "deviceId": User.deviceId]
        
        do{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON{ response in
                
                //                print (response.request!)
                //                print(response.response!)
                //                print(response.result)
                
                switch response.result{
                case .success:
                    statStatusCode = 0
                    statStatusMessage = "Success"
                case .failure( _):
                    statStatusCode = 0
                    statStatusMessage = "Registration Error"
                }
                completion(statStatusCode, statStatusMessage)
        }
    }
    
    func callServiceAuth(completion: @escaping (_ status: Int, _ statusMessage: String, _ token: String) -> ())
    {
        var statStatusCode = -1
        var statStatusMessage = "Error: Unknown"
        var statToken = ""
        
        let url = URL(string: intUrl + authSubUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        
        let params: Parameters = ["userEmail": authUser, "userPwd": authPassword, "app": "appService,address,macro,micro,modelr", "culture": "en"]
        
        do{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON{ response in
                
//                print (response.request!)
//                print(response.response!)
//                print(response.result)
                
                switch response.result{
                    case .success:
                        if let jsonData = response.result.value{
//                            print (jsonData)
                                
                            if let dictionary = jsonData as? [String: AnyObject]{
//                                    print(dictionary)
                                if let tokenType = dictionary["token_type"] as? String{
                                    statStatusCode = 0
                                    statStatusMessage = "Success"
                                    statToken = "\(tokenType)"
                                }
                                if let token = dictionary["token"] as? String{
                                    statStatusCode = 0
                                    statStatusMessage = "Success"
                                    statToken = "\(statToken) \(token)"
                                }
                            }
                            
                    }
                    case .failure( _):
                        
                        statStatusCode = 0
                        statStatusMessage = "Auth Error"
                }
                completion(statStatusCode, statStatusMessage, statToken)
            }
    }
    
    func callImageService(propertyData: PropertyData, completion: @escaping (_ status: Int) -> ()){
        var statStatus: Int = -1
        
        let url = URL(string: intUrl + appSubImageProcessingUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        
        let params: Parameters = ["imageBase64": "base ",
                                  "latitude": propertyData.vLatitude,
                                  "longitude": propertyData.vLongitude]
        
        do{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(propertyData.authToken, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON{ response in
                print (response.request!)
//                print(response.response!)
//                print(response.result)
                switch response.result{
                case .success:
                    if let jsonData = response.result.value{
//                        print (jsonData)
                        
                        if let dictionary = jsonData as? [String: AnyObject]{
                            
                            if let jZip = dictionary["zip"] as? String{
                                propertyData.zip.next(jZip)
                            }
                            if let jTown = dictionary["town"] as? String{
                                propertyData.town.next(jTown)
                            }
                            if let jStreet = dictionary["street"] as? String{
                                propertyData.street.next(jStreet)
                            }
                            if let jCountry = dictionary["country"] as? String{
                                propertyData.country.next(jCountry)
                            }
                            if let jCategory = dictionary["category"] as? String{
                                propertyData.category.next(jCategory)
                            }
                            if let jAppraisalValue = dictionary["appraisalValue"] as? Float{
                                propertyData.appraisalValue.next(jAppraisalValue)
                            }
                            if let jRating = dictionary["rating"] as? Float{
                                propertyData.rating.next(jRating)
                            }
                            if let jCatCode = dictionary["catCode"] as? Int{
                                propertyData.catCode.next(jCatCode)
                            }
                        }
                        
                    }
                case .failure( _):
                    debugPrint(response)
                    
                    statStatus = -1
                    print("error")
                }
                
                completion(statStatus)
        }
    }
    
    func saveFile(text: String)
    {
        let file = "file1.txt" //this is the file. we will write to and read from it
        
//        let text = "some text" //just a text
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            
            //writing
            do {
                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */
                print("erro")
            }
            
            //reading
//            do {
//                let text2 = try String(contentsOf: path, encoding: String.Encoding.utf8)
//            }
//            catch {/* error handling here */}
        }
    }
    
    func callOfferedRentDefaultService(propertyData: PropertyInfo, completion: @escaping (_ status: Int) -> ()){
        var statStatus: Int = 0
        
        let url = URL(string: intUrl + "/apps/v1/defaultOfferedRentAppraisal")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
//        let params: Parameters = [ "imageBase64": "base",
        let params: Parameters = [ "imageBase64": "\(propertyData.imageBase64String!)",
                                  "lat": propertyData.latitude.value,
                                  "lng": propertyData.longitude.value,
                                  "deviceId": User.deviceId]
        
//        saveFile(text: "data:image/jpeg;base64, \(propertyData.imageBase64String!)")
//        debugPrint(params)

        do{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
//        urlRequest.setValue(propertyData.authToken, forHTTPHeaderField: "Authorization")
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 2000
        
        manager.request(urlRequest)
            .validate()
            .responseJSON{ response in
//                print (response.request!)
//                print(response.response!)
//                print(response.result)
                
                switch response.result{
                case .success:
                    if let jsonData = response.result.value{
                       // print (jsonData)
                        
                            if let dictionary = jsonData as? [String: AnyObject]{
                                
                                if let value = dictionary["ortId"] as? Int{
                                    propertyData.ortId.next(value)
                                }
                                if let value = dictionary["zip"] as? String{
                                    propertyData.zip.next(value)
                                }
                                if let value = dictionary["town"] as? String{
                                    propertyData.town.next(value)
                                }
                                if let value = dictionary["street"] as? String{
                                    propertyData.street.next(value)
                                }
                                if let value = dictionary["country"] as? String{
                                    propertyData.country.next(value)
                                }
                                if let value = dictionary["category"] as? String{
                                    propertyData.category.next(value)
                                }
                                if let value = dictionary["catCode"] as? Int{
                                    propertyData.catCode.next(value)
                                }
                                if let value = dictionary["objectType"] as? String{
                                    propertyData.propertyTypeCodeText.next(value)
                                }
                                if let value = dictionary["objectTypeCode"] as? Int{
                                    propertyData.propertyTypeCode.next(value)
                                }
                                if let value = dictionary["appraisalValue"] as? Float{
                                    propertyData.appraisalValue.next(value)
                                }
                                if let value = dictionary["microRating"] as? Float{
                                    propertyData.rating.next(value)
                                }
                                if let value = dictionary["surfaceContract"] as? Float{
                                    propertyData.surfaceContract.next(value)
                                }
                                if let value = dictionary["roomNb"] as? Float{
                                    propertyData.roomNb.next(value)
                                }
                                if let value = dictionary["buildYear"] as? Int{
                                    propertyData.buildYear.next(value)
                                }
                                if let value = dictionary["lift"] as? Int{
                                    propertyData.lift.next(value)
                                }
                        }
                    }
                case .failure( let error):
                    debugPrint(response)
                    
                    statStatus = -1
                    print("error")
                    print(error._code)
                    print(error.localizedDescription)
                    
                    if let data = response.data {
                        if let json = String(data: data, encoding: String.Encoding.utf8) {
                            print(json)
                        }
                    }
                }
                
                completion(statStatus)
        }
    }
    
    func callOfferedRentService(propertyData: PropertyInfo, completion: @escaping (_ status: Int) -> ()){
        var statStatus: Int = 0
        
        let url = URL(string: intUrl + "/apps/v1/OfferedRentAppraisal")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        let addressParams: Parameters = [ "address": "\(propertyData.street.value), \(propertyData.zip.value) \(propertyData.town.value), \(propertyData.country.value)",
                                        "street": propertyData.street.value,
                                        "zip": propertyData.zip.value,
                                        "town": propertyData.town.value,
                                        "country": "\(propertyData.country.value)",
                                        "lat": "\(propertyData.latitude.value)",
                                        "lng": "\(propertyData.longitude.value)"]
        
        
        let params: Parameters = ["ortId": "\(propertyData.ortId.value)",
                                  "externalKey": "RPI_TEST",
                                  "categoryCode": "\(propertyData.catCode.value)",
                                  "objectTypeCode": "\(propertyData.propertyTypeCode.value)",
                                  "qualityMicro": "\(propertyData.rating.value)",
                                  "surfaceContract": "\(Int(propertyData.surfaceContract.value))",
                                  "buildYear": "\(propertyData.buildYear.value)",
                                  "roomNb": "\(propertyData.roomNb.value)",
                                  "lift": "\(propertyData.lift.value)",
                                  "deviceId": "\(User.deviceId)",
                                  "address": addressParams]
        
        debugPrint(params)
        
        do{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(propertyData.authToken, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON{ response in
                print (response.request!)
                //                print(response.response!)
                //                print(response.result)
                switch response.result{
                case .success:
                    if let jsonData = response.result.value{
                        // print (jsonData)
                        
                        if let dictionary = jsonData as? [String: AnyObject]{
                            
                            if let value = dictionary["ortId"] as? Int{
                                propertyData.ortId.next(value)
                            }
                            if let value = dictionary["zip"] as? String{
                                propertyData.zip.next(value)
                            }
                            if let value = dictionary["town"] as? String{
                                propertyData.town.next(value)
                            }
                            if let value = dictionary["street"] as? String{
                                propertyData.street.next(value)
                            }
                            if let value = dictionary["country"] as? String{
                                propertyData.country.next(value)
                            }
                            if let value = dictionary["category"] as? String{
                                propertyData.category.next(value)
                            }
                            if let value = dictionary["catCode"] as? Int{
                                propertyData.catCode.next(value)
                            }
                            if let value = dictionary["objectType"] as? String{
                                propertyData.propertyTypeCodeText.next(value)
                            }
                            if let value = dictionary["objectTypeCode"] as? Int{
                                propertyData.propertyTypeCode.next(value)
                            }
                            if let value = dictionary["appraisalValue"] as? Float{
                                propertyData.appraisalValue.next(value)
                            }
                            if let value = dictionary["microRating"] as? Float{
                                propertyData.rating.next(value)
                            }
                            if let value = dictionary["surfaceContract"] as? Float{
                                propertyData.surfaceContract.next(value)
                            }
                            if let value = dictionary["roomNb"] as? Float{
                                propertyData.roomNb.next(value)
                            }
                            if let value = dictionary["buildYear"] as? Int{
                                propertyData.buildYear.next(value)
                            }
                            if let value = dictionary["lift"] as? Int{
                                propertyData.lift.next(value)
                            }
                        }
                    }
                case .failure( let error):
                    debugPrint(response)
                    
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print(json!)
                    }
                    statStatus = -1
                    print("error")
                    print(error._code)
                    print(error.localizedDescription)
                }
                
                completion(statStatus)
        }
    }
    
    func callAppraiseService(propertyData: PropertyData, completion: @escaping (_ status: Int) -> ()){
        
        var statStatus: Int = -1
        
        let url = URL(string: intUrl + appSubAppraisePropertyUrl)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        
        let params: Parameters = ["surfaceLiving": Int(propertyData.vSurfaceLiving),
                                  "landSurface": Int(propertyData.vLandSurface),
                                  "roomNb": propertyData.vRoomNb,
                                  "bathNb": Int(propertyData.vBathNb),
                                  "buildYear": Int(propertyData.vBuildYear),
                                  "microRating": propertyData.vRating,
                                  "catCode": Int(propertyData.vCatCode),
//                                  "zip": Int(propertyData.vZip) ?? default "",
                                  "town": propertyData.vTown,
                                  "street": propertyData.vStreet,
                                  "country": propertyData.vCountry]
//        debugPrint(params)
        do{
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue(propertyData.authToken, forHTTPHeaderField: "Authorization")
        
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON{ response in
//                print (response.request!)
                //                print(response.response!)
                //                print(response.result)
                switch response.result{
                case .success:
                    if let jsonData = response.result.value{
//                        print (jsonData)
                            if let dictionary = jsonData as? [String: AnyObject]{
                                
                                if let jZip = dictionary["zip"] as? String{
                                    propertyData.zip.next(jZip)
                                }
                                if let jTown = dictionary["town"] as? String{
                                    propertyData.town.next(jTown)
                                }
                                if let jStreet = dictionary["street"] as? String{
                                    propertyData.street.next(jStreet)
                                }
                                if let jCountry = dictionary["country"] as? String{
                                    propertyData.country.next(jCountry)
                                }
                                if let jCategory = dictionary["category"] as? String{
                                    propertyData.category.next(jCategory)
                                }
                                if let jAppraisalValue = dictionary["appraisalValue"] as? Float{
                                    propertyData.appraisalValue.next(jAppraisalValue)
                                }
                                if let jRating = dictionary["rating"] as? Float{
                                    propertyData.rating.next(jRating)
                                }
                                if let jCatCode = dictionary["catCode"] as? Int{
                                    propertyData.catCode.next(jCatCode)
                                }
                            }
                    }
                case .failure( _):
                    debugPrint(response)
                    
                    statStatus = -1
                    print("error")
                }
                
                completion(statStatus)
        }
    }
}
