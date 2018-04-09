//
//  ForecastService.swift
//  Weezer
//
//  Created by Anton on 07/04/2018.
//  Copyright © 2018 milording. All rights reserved.
//

import UIKit
import SwiftyJSON

class ForecastService: NSObject {
    
    private static var sharedForecastService: ForecastService = {
        let forecastService = ForecastService()
        
        return forecastService
    }()
    var forecastHolder = [Forecast]()
    
    private override init() {
        
    }
    
    class func shared() -> ForecastService {
        return sharedForecastService
    }
    
    let apiKey : String = "984738d2d7471e90b6797f917b896086"
    var urlPath: String!
    
    func addForecast(city: String, countryCode: String, completion: @escaping (Forecast)-> Void) {
        urlPath = "http://api.openweathermap.org/data/2.5/forecast?q=\(city),\(countryCode)&units=metric&appid=\(apiKey)"
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        getForecast(urlToRequest: urlPath) { forecast in
            if(self.forecastHolder.contains(forecast)) {
                completion(forecast)
            }
            completion(forecast)
        }
    }
    
    private func getForecast(urlToRequest: String, completion: @escaping (Forecast)-> ()) {
        var forecast  = Forecast()
        URLSession.shared.dataTask(with: URL(string: urlToRequest)!) { (data, response, error) -> Void in
            if error == nil && data != nil {
                forecast = self.parseJSON(jsonData: data!)
                completion(forecast)
            }}.resume()
    }
    
    private func parseJSON(jsonData: Data) -> Forecast {
        let json = try! JSON(data: jsonData)
        let city = json["city"]["name"].stringValue
        let country = json["city"]["country"].stringValue
        let dates = json["list"].arrayValue.map({$0["dt_txt"].stringValue})
        let temperatures = json["list"].arrayValue.map({$0["main"]["temp"].stringValue})
        var calendarDates = [Date]()
        
        for date in dates {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let rawDate = dateFormatter.date(from: date)!
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: rawDate)
            let finalDate = calendar.date(from: components)!
            calendarDates.append(finalDate)
        }
        
        var forecastData = [ForecastData]()
        for index in 0...calendarDates.count-1 {
            let forecast = ForecastData()
            forecast.date = calendarDates[index]
            let tempInt = Int(Float(temperatures[index])!)
            
            forecast.temperature = tempInt
            forecastData.append(forecast)
        }
        
        let forecast = Forecast()
        forecast.city = city
        forecast.country = country
        forecast.data = forecastData
        
        return forecast
    }
}
