//
//  Forecast.swift
//  Weezer
//
//  Created by Anton on 07/04/2018.
//  Copyright © 2018 milording. All rights reserved.
//

import UIKit

class Forecast: NSObject {
    var data = [ForecastData]()
    var city : String = ""
    var country : String = ""
}

class ForecastData: NSObject {
    var date : Date? = nil
    var temperature : Int = 0
}
