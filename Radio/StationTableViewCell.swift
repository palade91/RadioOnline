//
//  StationTableViewCell.swift
//  Radio
//
//  Created by Catalin Palade on 08/08/2018.
//  Copyright © 2018 Catalin Palade. All rights reserved.
//

import UIKit

class StationTableViewCell: UITableViewCell {
    
    @IBOutlet var stationImageView: UIImageView!
    @IBOutlet var stationNameLabel: UILabel!
    @IBOutlet var stationDetailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureStationCell(station: RadioStation) {
        stationNameLabel.text = station.name
        stationDetailLabel.text = station.motto
        stationImageView.image = station.logo
    }
    
    
    
}
