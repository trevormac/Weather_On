//
//  CurrentWeather.swift
//  Weather_On
//
//  Created by Trevor MacGregor on 2017-05-12.
//  Copyright © 2017 TeevoCo. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Int!
    
    var forecasts = [Forecast]()
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "\(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Int {
        if _currentTemp == nil {
            _currentTemp = 0
        }
        return _currentTemp
    }
    
    
    func downloadWeatherDetails(completed: @escaping  DownloadComplete) {
        //AlamoFire download: after we request it, we put it into a response. Then we assign our values to our vars
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result
            print(response)
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        print(self._weatherType)
                    }
                }
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    
                    if let currentTemperature = main["temp"] as? Double {
                        
                        let kelvinToCelsiusDbl = round(currentTemperature - 273.15)
                        
                        let kelvinToCelsius = Int(kelvinToCelsiusDbl)
                        
                        self._currentTemp = kelvinToCelsius
                        print(self._currentTemp)
                    }
                }
            }
            completed()
        }
        
    }
    
    func downloadForecastData(completed: @escaping  DownloadComplete) {
        //downloading forecast weather data for tableview
        
        Alamofire.request(FORECAST_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                //run through the json dict and for every forecast we find we add it to another dictionary
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                        //print(obj)
                    }
                    //removes 1st slot in array to get tomorrows weather for the 1st cell
                    self.forecasts.remove(at: 0)
                 
                }
            }
            completed()
        }
        
    }

}
