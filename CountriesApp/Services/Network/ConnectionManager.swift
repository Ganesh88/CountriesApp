//
//  ConnectionManager.swift
//  CountriesApp
//
//  Created by ganesh Pathe on 28/11/18.
//  Copyright © 2018 Cybage Software Pvt. Ltd. All rights reserved.
//

import Foundation

struct ErrorMessage {
    
    // MARK: Instance properties
    
    /**
     It says about http status code
     */
    private let statusCode : Int?
    
    /**
     It says about status message
     */
    private let statusMessage : String?
    
    /**
     It says about error message
     */
    private let errorMessage : String?
    
    // MARK: Initializers
    
    /**
     Initializer
     
     - parameters:
     - statusCode : Http Status code.
     - statusMessage : Http Status message.
     - errorMessage: Error message to be shown.
     */
    init(statuCode sCode: Int? , statusMessage sMessage: String?, errorMessage eMessage: String?) {
        self.statusCode = sCode
        self.statusMessage = sMessage
        self.errorMessage = eMessage
    }
    
    // MARK: Instance Methods
    /**
     It says about http status code
     
     - returns: http status code.
     */
    func statusCodeValue() -> Int? {
        return self.statusCode
    }
    
    /**
     It says about status message
     
     - returns: http status message.
     */
    func statusMessageValue() -> String? {
        return self.statusMessage
    }
    
    /**
     It says about error message
     
     - returns: http error message.
     */
    func errorMessageValue() -> String? {
        return self.errorMessage
    }
}

class ConnectionManager : NSObject {
    
    // MARK: - Properties
    
    /// array of active connections.
    var activeConnections = [URLSessionDataTask : Request]()
    
    /// download session for DownloadManager
    lazy var connectionSession : URLSession = { [unowned self] in
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        return session
        
        }()
    
    /// ConnectionManager sharedInstance
    static let sharedInstance = ConnectionManager()
    
    // MARK: - Class LifeCycle Methods
    
    private override init() {
        
        super.init()
        
        _ = self.connectionSession
        
    }
    
    deinit {
        //print("download manager deinit")
        
    }
    
    // MARK: - Instance methods
    
    /**
     start downloading with download object
     
     - parameter download: Download object which represent remote url and other stuff
     */
    func start(request requestObject : Request) {
        
        var request: NSMutableURLRequest = NSMutableURLRequest(url: URL(string: "https://www.google.com/")!)
        
        // If condition goes if request is GET
        if requestObject.httpMethod == .get {

            let urlObj = requestObject.requestURL() as URL
            var url = URLComponents(string: urlObj.absoluteString)!
            var urlQueryItmes = [URLQueryItem]()
            
            if requestObject.dictParams.isEmpty == false {
                let dictParams = requestObject.dictParams
                for (key, value) in dictParams {
                    if let value = value as? String {
                        urlQueryItmes.append(URLQueryItem(name: key, value: value))
                    }
                }
            }
            
            url.queryItems = urlQueryItmes
            
            request = NSMutableURLRequest(url: url.url!)

            // This is GET request
            request.httpMethod = "GET"
            
            
        } else if requestObject.httpMethod == .post {
            // If condition goes if request is POST
            
            request = NSMutableURLRequest(url: requestObject.requestURL() as URL)
            
            // This is post request
            request.httpMethod = "POST"
            
            let body = NSMutableData()
            
            //define the data post parameter
            
            if requestObject.dictParams.isEmpty == false {
                let dictParams = requestObject.dictParams
                for key in dictParams.keys {
                    body.append("Content-Disposition:form-data; name=\"\(key)\"\r\n\r\n".data(using: String.Encoding.utf8)!)
                    if let value = dictParams[key] {
                        body.append("\(value)\r\n".data(using: String.Encoding.utf8)!)
                    }
                }
            }
            
            request.httpBody = body as Data
            
        }
        
        for key in requestObject.dictHeaderKeyValues.keys {
            if let value = requestObject.dictHeaderKeyValues[key] {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let dataTask : URLSessionDataTask = self.connectionSession.dataTask(with: request as URLRequest)
        
        activeConnections[dataTask] = requestObject
        dataTask.resume()
        
    }
}

extension ConnectionManager : URLSessionDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        let credential:URLCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, credential)
    }
}

extension ConnectionManager : URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        if let request = activeConnections[dataTask] {
            let responseData = request.responseData
            responseData.append(data)
            
            if request.expectedContentLength > 0 {
                request.progress = Float(responseData.length) / Float(request.expectedContentLength)
            }
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(URLSession.ResponseDisposition.allow)
        
        //let expectedContentLength = Int(response.expectedContentLength)
        if let request = activeConnections[dataTask] {
            request.expectedContentLength = response.expectedContentLength
            //print("expectedContentLength  === \(request.expectedContentLength)")
        }
        
    }
    
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        //print("did complete with error")
        
        if let dataTask = task as? URLSessionDataTask, let request = activeConnections[dataTask] {
            
            let httpResponse = dataTask.response as? HTTPURLResponse
            
            //print("staus code == \(String(describing: httpResponse?.statusCode))")
            
            if let errorObject = error {
                print("error found in connecting == \(errorObject.localizedDescription)")
                
                request.failureHandler?(nil,httpResponse,errorObject)
                activeConnections[dataTask] = nil
            } else {
                
                // Success
                let responseData = request.responseData
                request.successHandler?(responseData as Data?,httpResponse)
                activeConnections[dataTask] = nil
            }
        }
    }
}
