//
//  ViewController.swift
//  Networking
//
//  Created by user239775 on 3/29/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    //Location manager
    let manager = CLLocationManager()
    
    // Label for location
    @IBOutlet weak var labelLocation: UILabel!
    
    // Label for weather type
    @IBOutlet weak var labelWeather: UILabel!
    
    // Image for weather icon
    @IBOutlet weak var imageIcon: UIImageView!
    
    // Label for temperature
    @IBOutlet weak var labelTemp: UILabel!
    
    // Label for humidity
    @IBOutlet weak var labelHumidity: UILabel!
    
    // Label for wind speed
    @IBOutlet weak var labelWind: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set location manager settings and start updating location
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    // Set location and pass to API call
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location: [CLLocation]) {
        manager.startUpdatingLocation()
        
        // Attempt to get current location
        guard let currentLocation = manager.location
        else {
            return
        }
        
        // Pass location to API call
        makeAPICalltoGetData(location: currentLocation)
    }
    
    // Get JSON data
    func makeAPICalltoGetData(location: CLLocation) {
        // Location coordinates
        let coordinate = location.coordinate
        
        //Waterloo coordinates
        print("Waterloo coordinates:")
        print("Latitude: 43.4643")
        print("Longitude: -80.5204")
        
        // Create URL using location latitude and longitude
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(String(describing: coordinate.latitude))&lon=\(String(describing: coordinate.longitude))&appid=d3f0956caa7ad29a06e029f9a9cb7c0e") else { return }
        
        
        // Fetch JSON data from server using URL
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            // If data received from server, proceed
            if let data = data {
                do {
                    print(String(data: data, encoding: .utf8) ?? "No data")
                    
                    // Decode data using Weather struct
                    let jsonData = try JSONDecoder().decode(Weather.self, from: data)
                    
                    // Pass weather data to update labels on view thread
                    DispatchQueue.main.async {
                        self.updateLabels(weather: jsonData)
                    }
                } catch {
                    print("Error decoding data.")
                }
            } else {
                print("Error getting data from server.")
            }
        }
        task.resume()
    }
    
    // Get weather icon image
    func getImage(icon: String) {
        // Create URL using icon string
        guard let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") else { return }
        
        // Fetch image from server using URL
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            // If image received from server, proceed
            if let data = data {
                // Set image to received icon on main thread
                DispatchQueue.main.async {
                    self.imageIcon.image = UIImage(data: data)
                }
            } else {
                print("Error getting icon from server.")
            }
        }
        task.resume()
    }
    
    // Update view with weather data
    func updateLabels(weather: Weather) {
        // Get needed variables from decoded data
        let name = weather.name
        let weatherText = weather.weather[0].main
        let icon = weather.weather[0].icon
        let temp = Int(weather.main.temp - 273.15)
        let humidity = weather.main.humidity
        let wind = weather.wind.speed
        
        // Set labels to corresponding variables
        labelLocation.text = name
        labelWeather.text = weatherText
        labelTemp.text = "\(temp)°"
        labelHumidity.text = "Humidity: \(humidity)%"
        labelWind.text = "Wind: \(wind) km/h"
        
        // Get icon image
        getImage(icon: icon)
    }
}

