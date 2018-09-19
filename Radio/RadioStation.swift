//
//  RadioStation.swift
//  Radio
//
//  Created by Catalin Palade on 08/08/2018.
//  Copyright © 2018 Catalin Palade. All rights reserved.
//

import UIKit

class RadioStation: NSObject {

    var name: String
    var motto: String
    var streamURL: String
    var logo: UIImage
    
    init(name: String, motto: String, streamURL: String, logo: UIImage) {
        self.name = name
        self.motto = motto
        self.streamURL = streamURL
        self.logo = logo
    }
    
}
