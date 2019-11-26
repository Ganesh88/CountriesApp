//
//  Request.swift
//  CountriesApp
//
//  Created by ganesh Pathe on 28/11/18.
//  Copyright © 2018 Cybage Software Pvt. Ltd. All rights reserved.
//

import Foundation

enum HttpMethod {
    
    case get // type is Get
    case post // Type is Post
}

class Request {
    
    // MARK: - Instance Properties
    private let url : String
    
    // request method type , default its set to GET .
    var httpMethod : HttpMethod = .get
    
    // Request which is having parameters
    var dictParams = [String : Any]()
    
    // Request header key-values .
    var dictHeaderKeyValues = [String:String]()
    
    // Success Handler
    var successHandler : (( _ responseData : Data?, _ httpResponse : HTTPURLResponse?) -> Void)?
    
    // Failure Handler
    var failureHandler : ((_ responseData : Data?, _ httpResponse: HTTPURLResponse?, _ error: Error) -> Void)?
    
    // Progress Handler
    var progressHandler : ((_ progress : Float) -> Void)?
    
    // Reference to mutable data.
    var responseData = NSMutableData()
    
    // Reference to expected response length
    var expectedContentLength : Int64 = 0
    
    // it states about the progress of the response being received.
    var progress : Float = 0.0 {
        didSet{
            if let pHandler = progressHandler {
                pHandler(self.progress)
            }
        }
    }
    
    // MARK: - Initializers
    init(withURL url : String) {
        self.url = url
    }
    
    // MARK: - Class Methods
    func requestURL() -> NSURL {
        if let requestURL = NSURL(string: self.url) {
            return requestURL
        }
        return NSURL()
    }
    
    // MARK: - Instance Methods
    
    /**
     It set parameters to be sent in request.
     
     - parameters:
     - paramValue: parameter value.
     - paramKey: parameter key.
     */
    func setParams(paramValue value : String, paramKey key : String) {
        dictParams[key] = value
    }
    
    /**
     It set header key - values
     
     - parameters:
     - value: Header Value.
     - forKey: Header Key.
     */
    func setHeader(value headerValue : String , forKey headerKey :String) {
        dictHeaderKeyValues[headerKey] = headerValue
    }
}
