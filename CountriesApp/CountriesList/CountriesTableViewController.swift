//
//  CountriesTableViewController.swift
//  CountriesApp
//
//  Created by ganesh Pathe on 25/11/19.
//  Copyright © 2019 Ganesh Pathe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CountriesTableViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var countrisListTableView: UITableView!
    
    var countriesData = CountryModel()
    var countriesArrray = [CountryModel]()
    var countriesListViewModel: CountriesListViewModel? {
        didSet{
            viewModelBindings(viewModel: countriesListViewModel!)
        }
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        countriesListViewModel = CountriesListViewModel(searchingTag: searchBar.rx.text.orEmpty.asObservable(), service: AppDelegate.getServiceFactory().getCountriesListService())
    }
    
    
    func viewModelBindings(viewModel: CountriesListViewModel) {
        
        countriesListViewModel?.countriesArray.asObservable().bind{
            [unowned self] countriesArrray in
            self.countriesArrray = countriesArrray
            self.countrisListTableView.reloadData()
            }.disposed(by: disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CountriesTableViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesArrray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CountryListTableViewCell", for: indexPath) as? CountryListTableViewCell
        cell?.configureCell(countryModel: countriesArrray[indexPath.row])
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
