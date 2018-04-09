//
//  ForecastViewController.swift
//  Weezer
//
//  Created by Anton on 07/04/2018.
//  Copyright © 2018 milording. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    
    private var myTableView: UITableView!
    var weekForecast: Forecast!
    
    var currentTemperature : UILabel = UILabel(frame: CGRect(x: 100, y: 200, width: 100, height: 50))
    var forecastService : ForecastService = ForecastService.shared()
    
    init(city: String, countryCode: String) {
        super.init(nibName: nil, bundle: nil)
        
        forecastService.addForecast(city: city, countryCode: countryCode) { forecast in
            DispatchQueue.main.async {
                self.weekForecast = forecast
                self.loadTableView()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(currentTemperature)
    }
    
    // MARK: - UI Init
    private func loadTableView()
    {
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight-barHeight), style: UITableViewStyle.grouped)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
}

// MARK: - UITableViewDataSource
extension ForecastViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        if(weekForecast==nil) {
            return cell;
        }
        
        let rowsInSection = self.tableView(myTableView, numberOfRowsInSection: indexPath.section)
        cell.textLabel!.text = "\(weekForecast.data[indexPath.row+(indexPath.section*rowsInSection)].temperature) °C"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var daysOfWeek = [String]()
        
        for forecast in weekForecast.data {
            let currentDate = forecast.date
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 4)
            dateFormatter.dateFormat = "ccc"
            
            let weekDay = dateFormatter.string(from: currentDate!)
            if(daysOfWeek.contains(weekDay)) {
                continue
            }
            daysOfWeek.append(weekDay)
        }
        
        return daysOfWeek[section];
    }
}

// MARK: - UITableViewDelegate
extension ForecastViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print()
    }
}
