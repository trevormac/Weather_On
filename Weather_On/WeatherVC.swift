//
//  ViewController.swift
//  Weather_On
//
//  Created by Trevor MacGregor on 2017-05-12.
//  Copyright © 2017 TeevoCo. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class WeatherVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImage: UIImageView!
    @IBOutlet weak var currentWeatherLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var currentWeather: CurrentWeather!
    var forecast: Forecast!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.startUpdatingLocation()
        locationManager.requestLocation()
        currentLocation = nil
        
        tableView.delegate = self
        tableView.dataSource = self
        currentWeather  = CurrentWeather()
         
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    
    func locationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            locationManager.requestLocation() //implements didUpdateLocations delegate see below
            
        }else{
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus() //recursive
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation //an array of CLLocations
        
        //currentLocation = locationManager.location
        Location.sharedInstance.latitude = userLocation.coordinate.latitude
        Location.sharedInstance.longitude = userLocation.coordinate.longitude
        
        //update UI with new data
        currentWeather = CurrentWeather()
        self.currentWeather.downloadWeatherDetails{
            
           self.currentWeather.downloadForecastData{
                //Update UI
            
                self.tableView.reloadData()
                self.updateMainUI()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //If requestLocation() fails then default to Toronto Coordinates
        Location.sharedInstance.latitude = 43.6532
        Location.sharedInstance.longitude = -79.3832
        
        //Update UI with default data
        currentWeather = CurrentWeather()
        currentWeather.downloadWeatherDetails{
           
            self.currentWeather.downloadForecastData{
                //Update UI
                
                self.tableView.reloadData()
                self.updateMainUI()
            }
        }
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWeather.forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as? WeatherCell {
            let forecast = currentWeather.forecasts[indexPath.row]
            cell.configureCell(forecast: forecast)
            return cell
        }else {
            return WeatherCell()
        }
        
    }
    
    func updateMainUI() {
        dateLabel.text = currentWeather.date
        currentTempLabel.text = "\(currentWeather.currentTemp)°"
        locationLabel.text = currentWeather.cityName
        currentWeatherLabel.text = currentWeather.weatherType
        //passes in the asset which is named exactly like the "weathertype" value coming in
        currentWeatherImage.image = UIImage(named: currentWeather.weatherType)
    }

   

}

