//
//  ViewController.swift
//  Weezer
//
//  Created by Anton on 07/04/2018.
//  Copyright © 2018 milording. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var pageControl : UIPageControl = UIPageControl(frame: CGRect(x: 50, y: 300, width: 200, height: 20))
    let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
    var forecastArray = [ForecastViewController]()
    
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
        super.init(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        let firstVC = ForecastViewController(city: "Moscow", countryCode: "RU")
        forecastArray.append(firstVC)
        forecastArray.append(ForecastViewController(city: "Amsterdam", countryCode: "NL"))
        forecastArray.append(ForecastViewController(city: "Rome", countryCode: "IT"))
        
        self.view.backgroundColor = UIColor.white
        
        let viewControllers = [firstVC]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let forecastHolder = ForecastService.shared().forecastHolder
        if(forecastHolder.count != 0 ) {
            for forecast in  forecastHolder{
                forecastArray.append(ForecastViewController(city: forecast.city, countryCode: forecast.country))
            }
            ForecastService.shared().forecastHolder = [Forecast]()
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension PageViewController:UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        let forecastController = viewController as! ForecastViewController
        let currentIndex = forecastArray.index(of: forecastController)!
        
        if(currentIndex    < forecastArray.count-1) {
            self.navigationItem.title = forecastArray[currentIndex+1].weekForecast.city
            return forecastArray[currentIndex+1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let forecastController = viewController as! ForecastViewController
        
        let currentIndex = forecastArray.index(of: forecastController)!
        
        if(currentIndex > 0) {
            self.navigationItem.title = forecastArray[currentIndex-1].weekForecast.city
            return forecastArray[currentIndex-1]
        }
        return nil
    }
}

