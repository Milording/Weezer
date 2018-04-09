//
//  SearchViewController.swift
//  Weezer
//
//  Created by Anton on 08/04/2018.
//  Copyright © 2018 milording. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    var typedText : String!
    var searchBar : UISearchBar!
    var resultsTableView : UITableView!
    
    var searchService = SearchService()
    var searchResults = SearchResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
    }
    
    // MARK: UI Init
    func createUI() {
        self.title = "Search"
        self.view.backgroundColor = UIColor.white
        
        initSearchBar()
        initTableView()
    }
    
    func initSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(64)
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(50)
            make.centerX.equalTo(self.view.center.x)
        }
    }
    
    func initTableView() {
        self.resultsTableView = UITableView()
        self.resultsTableView.delegate = self
        self.resultsTableView.dataSource = self
        self.resultsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        self.resultsTableView.backgroundColor = UIColor.white
        self.view.addSubview(self.resultsTableView)
        self.resultsTableView.snp.makeConstraints { (make)-> Void in
            make.top.equalTo(116)
            make.bottom.equalTo(0)
            make.width.equalTo(self.view.frame.width)
        }
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.suggestedCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath as IndexPath)
        cell.textLabel?.text = self.searchResults.suggestedCity[indexPath.row]
        
        return cell
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityTitle = self.searchResults.suggestedCity[indexPath.row]
        let addingAlert = UIAlertController(title: "New City", message: "Add \(cityTitle) to Favorites?", preferredStyle: .alert)
        addingAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            ForecastService.shared().addForecast(city: cityTitle, countryCode: "", completion: { (forecast) in
                ForecastService.shared().forecastHolder.append(forecast)
                DispatchQueue.main.async {
                    self.searchBar.text = ""
                    self.searchResults = SearchResult()
                    self.resultsTableView.reloadData()
                    self.tabBarController!.selectedIndex = 0
                }
            })
        }))
        addingAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
        }))
        
        present(addingAlert, animated: true, completion: nil)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController :UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.count<3) {
            return
        }
        self.typedText = searchText
        self.searchService.search(city: searchText) { (result) in
            print(result.suggestedCity)
            self.searchResults = result
            DispatchQueue.main.async {
                self.resultsTableView.reloadData()
            }
            
        }
    }
}

