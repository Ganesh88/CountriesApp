//
//  IServiceFactory.swift
//  CountriesApp
//
//  Created by ganesh Pathe on 25/11/19.
//  Copyright © 2019 Ganesh Pathe. All rights reserved.
//

import Foundation

protocol IServiceFactory {
    func getCountriesListService() -> CountriesListProtocol
}

