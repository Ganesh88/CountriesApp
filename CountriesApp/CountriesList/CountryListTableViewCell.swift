//
//  CountryListTableViewCell.swift
//  CountriesApp
//
//  Created by ganesh Pathe on 26/11/19.
//  Copyright © 2019 Ganesh Pathe. All rights reserved.
//

import UIKit
import SDWebImage

class CountryListTableViewCell: UITableViewCell {

    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var flagImageView: SDAnimatedImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(countryModel: CountryModel) {
        countryNameLabel.text = countryModel.name
        print("name",countryModel.name)
        print("population",countryModel.population?.doubleValue)
        //flagImageView.sd_setImage(with: URL(string: countryModel.flag!), placeholderImage: nil)
    }

}
