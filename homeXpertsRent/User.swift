//
//  User.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 08/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import ReactiveKit
import Bond

class User {
    
    static let deviceId = "1233049494930349"
    
    //Binding
    let firstName = Observable<String?>("")
    let lastName = Observable<String?>("")
    let email = Observable<String?>("")
    let phone = Observable<String?>("")
    
    
    init() {
    }
    
}
