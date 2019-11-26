//
//  CountriesListService.swift
//  CountriesApp
//
//  Created by ganesh Pathe on 25/11/19.
//  Copyright © 2019 Ganesh Pathe. All rights reserved.
//

import Foundation
import PromiseKit

class CountriesListService: CountriesListProtocol {
    func getCountriesListForSearchString(searchString: String) -> Promise<[CountryModel]> {
        return Promise {
            
            seal in

            let request = Request(withURL: String(format:countriesSearchURL,searchString))
           
            //print(url)
            request.httpMethod = .get
            //Success Handler
            request.successHandler = {(responseData : Data?, httpResponse : HTTPURLResponse?) -> Void  in
                //print("fetchPostsFromAPI success handler")
                if httpResponse?.statusCode == 200 {
                    guard responseData != nil else { return }
                    do{
                        //here dataResponse received from a network request
                        let jsonResponse = try JSONSerialization.jsonObject(with:
                            responseData!, options: [])
                        //print(jsonResponse) //Response result
                        if let theJSONData = try? JSONSerialization.data(
                            withJSONObject: jsonResponse,
                            options: []) {
                            let theJSONText = String(data: theJSONData,
                                                     encoding: .ascii)
                            print("JSON string = \(theJSONText!)")
                            
//                            var data = theJSONText?.data(using: .utf8)
                        }
//                        guard let jsonDict = jsonResponse as? [[String : Any]]  else {
//                            return
//                        }
                        let backgoundContext = Utility.instance.appDelegate.persistentContainer.newBackgroundContext()
                        let decoder = JSONDecoder()
                        if let context = CodingUserInfoKey.context {
                            decoder.userInfo[context] = backgoundContext
                        }
                        var countriesArray = [CountryModel]()
                        countriesArray = try JSONDecoder().decode([CountryModel].self, from: responseData!)
                        seal.fulfill(countriesArray)
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                        seal.reject(parsingError)
                    }
                    
                } else {
                    let error = NSError(domain:"", code:(httpResponse?.statusCode)!, userInfo:[ NSLocalizedDescriptionKey: klSomethingWentWrong])
                    seal.reject(error)
                    //print("failure in fetchPostsFromAPI success handler")
                }
            }
            
            //Failure Handler
            request.failureHandler = {(_ responseData : Data?, _ httpResponse: HTTPURLResponse?, _ error : Error) -> Void in
                seal.reject(error)
                print("fetchPostsFromAPI failure handler")
                
            }
            
            let connectionManager = ConnectionManager.sharedInstance
            connectionManager.start(request: request)
        }
    }
}
