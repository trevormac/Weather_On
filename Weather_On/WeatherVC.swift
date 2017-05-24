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
        currentLocation = nil
        
        tableView.delegate = self
        tableView.dataSource = self
        currentWeather  = CurrentWeather()
        //forecast = Forecast()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            //access our location and then save it to our singleton class
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            //now our location is accessible from anywhere within the app
            print(Location.sharedInstance.longitude,Location.sharedInstance.latitude)
            currentWeather.downloadWeatherDetails {
                self.currentWeather.downloadForecastData {
                    
                    self.updateMainUI()
                    self.tableView.reloadData()
                }
                
            }

        }else{
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
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

