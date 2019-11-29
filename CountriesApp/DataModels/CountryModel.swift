//
//  CountryModel.swift
//  CountriesApp
//
//  Created by ganesh Pathe on 26/11/19.
//  Copyright © 2019 Ganesh Pathe. All rights reserved.
//

import Foundation
import CoreData

class CountryModel: NSManagedObject, Codable {
    
    @NSManaged public var name: String?
    @NSManaged public var population: NSNumber?
    @NSManaged public var topLevelDomain: [String]?
    @NSManaged public var alpha2Code: String?
    @NSManaged public var alpha3Code: String?
    @NSManaged public var callingCodes: [String]?
    @NSManaged public var capital: String?
    @NSManaged public var altSpellings: [String]?
    @NSManaged public var region: String?
    @NSManaged public var subregion: String?
    @NSManaged public var latlng: [Double]?
    @NSManaged public var demonym: String?
    @NSManaged public var area: NSNumber?
    @NSManaged public var gini: NSNumber?
    @NSManaged public var timezones: [String]?
    @NSManaged public var borders: [String]?
    @NSManaged public var nativeName: String?
    @NSManaged public var numericCode: String?
    @NSManaged public var currencies: [[String:String]]?
    @NSManaged public var languages: [[String:String]]?
    @NSManaged public var translations: [String]?
    @NSManaged public var flag: String?
    @NSManaged public var regionalBlocs: [[String:Any]]?
    @NSManaged public var cioc: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case population
        case topLevelDomain
        case alpha2Code
        case alpha3Code
        case callingCodes
        case capital
        case altSpellings
        case region
        case subregion
        case latlng
        case demonym
        case area
        case gini
        case timezones
        case borders
        case nativeName
        case numericCode
        case currencies
        case languages
        case translations
        case flag
        case regionalBlocs
        case cioc
    }
    
    // MARK: - Decodable
    required convenience init(from decoder: Decoder) throws {
        let backgoundContext = Utility.instance.appDelegate.persistentContainer.newBackgroundContext()
//        guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else { fatalError() }
        guard let entity = NSEntityDescription.entity(forEntityName: "CountryModel", in: backgoundContext) else { fatalError() }
        
        self.init(entity: entity, insertInto: backgoundContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.population = NSNumber(value: try container.decodeIfPresent(Double.self, forKey: .population) ?? 0.0)
        self.topLevelDomain = try container.decodeIfPresent([String].self, forKey: .topLevelDomain)
        self.alpha2Code = try container.decodeIfPresent(String.self, forKey: .alpha2Code)
        self.alpha3Code = try container.decodeIfPresent(String.self, forKey: .alpha3Code)
        self.callingCodes = try container.decodeIfPresent([String].self, forKey: .callingCodes)
        self.capital = try container.decodeIfPresent(String.self, forKey: .capital)
        self.altSpellings = try container.decodeIfPresent([String].self, forKey: .altSpellings)
        self.region = try container.decodeIfPresent(String.self, forKey: .region)
        self.subregion = try container.decodeIfPresent(String.self, forKey: .name)
        self.latlng = try container.decodeIfPresent([Double].self, forKey: .latlng)
        self.demonym = try container.decodeIfPresent(String.self, forKey: .demonym)
        self.area = NSNumber(value: try container.decodeIfPresent(Double.self, forKey: .area) ?? 0.0)
        self.gini = NSNumber(value: try container.decodeIfPresent(Double.self, forKey: .gini) ?? 0.0)
        self.timezones = try container.decodeIfPresent([String].self, forKey: .timezones)
        self.borders = try container.decodeIfPresent([String].self, forKey: .borders)
        self.nativeName = try container.decodeIfPresent(String.self, forKey: .nativeName)
        self.numericCode = try container.decodeIfPresent(String.self, forKey: .numericCode)
        self.currencies = try container.decodeIfPresent([[String : String]].self, forKey: .currencies)
        self.languages = try container.decodeIfPresent([[String : String]].self, forKey: .languages)
        self.translations = try container.decodeIfPresent([String].self, forKey: .translations)
        self.flag = try container.decodeIfPresent(String.self, forKey: .flag)
        //self.regionalBlocs = try container.decodeIfPresent([[String : Any]].self, forKey: .regionalBlocs)
        self.cioc = try container.decodeIfPresent(String.self, forKey: .cioc)
    }
    
    // MARK: - Encodable
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(population?.doubleValue, forKey: .population)
        try container.encode(topLevelDomain, forKey: .topLevelDomain)
        try container.encode(alpha2Code, forKey: .alpha2Code)
        try container.encode(alpha3Code, forKey: .alpha3Code)
        try container.encode(callingCodes, forKey: .callingCodes)
        try container.encode(capital, forKey: .capital)
        try container.encode(altSpellings, forKey: .altSpellings)
        try container.encode(region, forKey: .region)
        try container.encode(subregion, forKey: .subregion)
        
        try container.encode(latlng, forKey: .latlng)
        try container.encode(demonym, forKey: .demonym)
        try container.encode(area?.doubleValue, forKey: .area)
        try container.encode(gini?.doubleValue, forKey: .gini)
        try container.encode(timezones, forKey: .timezones)
        try container.encode(borders, forKey: .borders)
        try container.encode(nativeName, forKey: .nativeName)
        try container.encode(currencies, forKey: .currencies)
        try container.encode(languages, forKey: .languages)
        try container.encode(translations, forKey: .translations)
        try container.encode(flag, forKey: .flag)
        //try container.encode(regionalBlocs, forKey: .regionalBlocs)
        try container.encode(cioc, forKey: .cioc)
        
    }

}


extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}
