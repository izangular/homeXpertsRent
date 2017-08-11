//
//  ValidationErrorType.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 08/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import Foundation

struct ValidationError: Error {
    
    public let message: String
    
    public init(message m: String) {
        message = m
    }
}

