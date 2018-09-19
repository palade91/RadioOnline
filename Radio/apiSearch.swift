//
//  apiSearch.swift
//  Radio
//
//  Created by Catalin Palade on 09/08/2018.
//  Copyright © 2018 Catalin Palade. All rights reserved.
//

import Foundation

let vc = ViewController()

func loadAPI(infoURL: String) {
    if let url = URL(string: infoURL) {
        if let data = try? String(contentsOf: url) {
            let json = JSON(parseJSON: data)
            let temp = json["songs", 0, "song"].stringValue
            print(temp)
            vc.currentSong = temp
        }
    }
}
            
            

