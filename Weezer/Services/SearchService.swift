//
//  SearchService.swift
//  Weezer
//
//  Created by Anton on 08/04/2018.
//  Copyright © 2018 milording. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchService: NSObject {
    
    let apiKey : String = "984738d2d7471e90b6797f917b896086"
    var searchResult = SearchResult()
    
    func search(city: String, completion: @escaping (SearchResult)-> ()) {
        var urlPath = "http://api.openweathermap.org/data/2.5/find?q=\(city)&type=like&appid=\(apiKey)"
        urlPath = urlPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        URLSession.shared.dataTask(with: URL(string: urlPath)!) { (data, response, error) -> Void in
            if error == nil && data != nil {
                if(data==nil){ return }
                self.searchResult = self.parseJSON(jsonData: data!)
                completion(self.searchResult)
            }}.resume()
    }
    
    private func parseJSON(jsonData: Data) -> SearchResult {
        let json = try! JSON(data: jsonData)
        let cities = json["list"].arrayValue.map({$0["name"].stringValue})
        if(cities.count==0) {
            return self.searchResult
        }
        let countries = json["list"].arrayValue.map({$0["sys"]["country"].stringValue})
        
        let searchResult = SearchResult()
        for index in 0...cities.count-1 {
            searchResult.suggestedCity.append("\(cities[index]), \(countries[index])")
        }
        
        return searchResult
    }
    
}
