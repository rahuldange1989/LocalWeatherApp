//
//  WeatherViewController.swift
//  LocalWeatherApp
//
//  Created by Rahul Dange on 06/02/20.
//  Copyright © 2020 Rahul Dange. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

	var locationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.getCurrentLocationInfo()
	}

	// MARK: - Internal methods -
	func getCurrentLocationInfo() {
		locationManager.delegate = self
		locationManager.distanceFilter = kCLDistanceFilterNone
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()

		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
			locationManager.startUpdatingLocation()
		} else {
			let alertView: UIAlertController = UIAlertController(title:"Location Permission needed", message: LOCATION_DISABLED_MESSAGE, preferredStyle: .alert)
			let cancelAlertAction = UIAlertAction.init(title: "Cancel", style: .default, handler: nil)
			let gotoSettingsAction = UIAlertAction(title: "Settings", style: .default) { (action) in
				UIApplication.shared.open(URL(string:"app-settings:root=LOCATION_SERVICES")!, options: [:], completionHandler: nil)
			}
			
            // Add the actions.
            alertView.addAction(gotoSettingsAction)
			alertView.addAction(cancelAlertAction)
            self.present(alertView, animated: true, completion: nil)
		}
	}
	
	func callGetWeatherInfoAPI(latitude: Double, longitude: Double) {
		// -- With current location we will call get weather info API
		let apiManager = APIManager()
		apiManager.getWeatherInfo(latitude: latitude, longitude: longitude) { [unowned self] (weatherResponse, result) in
			DispatchQueue.main.async {
				if result == .Success {
					print(weatherResponse!)
				} else if result == .NoInternet {
					Utility.showAlert(self, title: "No Internet", message: NO_NETWORK_ERROR_MSG)
				} else {
					Utility.showAlert(self, title: "Error", message: SERVER_ERROR_MSG)
				}
			}
		}
	}
	
	// MARk: - Event handler methods -
}

// MARK: - Location Manager delegate methods -
extension WeatherViewController: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		locationManager.stopUpdatingLocation()
		if let location = locations.last {
			// -- Get city name
			let geoCoder = CLGeocoder.init()
			geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
				guard let placemark = placemarks?.last else { return }
				self.title = "Weather Info : " + (placemark.locality ?? "")
			}
			
			self.callGetWeatherInfoAPI(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
}
