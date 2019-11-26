//
//  CountriesListViewModel.swift
//  CountriesApp
//
//  Created by ganesh Pathe on 25/11/19.
//  Copyright © 2019 Ganesh Pathe. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import PromiseKit

class CountriesListViewModel {
    var countriesArray = Variable<[CountryModel]>([])
    let countryListService : CountriesListProtocol
    
    let disposeBag = DisposeBag()
    
    init(searchingTag: Observable<String>, service: CountriesListProtocol){
        
        countryListService = service
        
        searchingTag
            .throttle(3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind{
                
                [unowned self] searchTag in
                self.getCountryList(searchPhrase: searchTag)
            }.disposed(by: disposeBag)
    }
    
    
    func getCountryList(searchPhrase: String) {
        
       Utility.instance.showHUDWithText(klLoading)
        
        firstly {
            
            //checkConnectivityOnce()
            countryListService.getCountriesListForSearchString(searchString: searchPhrase)
            
            }.done{
                countriesArray -> Void in
                self.countriesArray.value = countriesArray
            }.catch{
                error in
                
            }.finally {
                Utility.instance.hideHUD()
        }
    }
}
