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

	@IBOutlet weak var hourlyTableView: UITableView!
	@IBOutlet weak var pressureLabel: UILabel!
	@IBOutlet weak var visibilityLabel: UILabel!
	@IBOutlet weak var uvIndexLabel: UILabel!
	@IBOutlet weak var dewPointLabel: UILabel!
	@IBOutlet weak var humidityLabel: UILabel!
	@IBOutlet weak var windLabel: UILabel!
	@IBOutlet weak var summaryLabel: UILabel!
	@IBOutlet weak var temperatureLabel: UILabel!
	@IBOutlet weak var weatherImageView: UIImageView!
	
	var locationManager = CLLocationManager()
	var hourlyTableData: [Currently]  = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		// -- hide extra tableview lines
		self.hourlyTableView.tableFooterView = UIView()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.getCurrentLocationInfo()
	}

	// MARK: - Internal methods -
	func mapDataToUI(weatherRespone: WeatherResponse?) {
		guard let weatherRespObj = weatherRespone else { return }
		// -- assign weather image
		if let imageName = weatherRespObj.currently?.icon {
			do {
				self.weatherImageView.image = try UIImage.init(data: Data.init(contentsOf: URL.init(string: IMAGE_URL_PATH + imageName + ".png")!))
			} catch {
				print(error.localizedDescription)
			}
		}
		self.temperatureLabel.text = "\(Int( weatherRespObj.currently?.temperature?.rounded() ?? 0))° " + (weatherRespObj.currently?.summary ?? "")
		self.summaryLabel.text = weatherRespObj.hourly?.summary ?? ""
		self.windLabel.text = "\(Int(weatherRespObj.currently?.windSpeed?.rounded() ?? 0))" + " mph"
		self.humidityLabel.text = "\((weatherRespObj.currently?.humidity ?? 0) * 100)" + "%"
		self.dewPointLabel.text = "\(Int(weatherRespObj.currently?.dewPoint?.rounded() ?? 0))" + "°"
		self.uvIndexLabel.text = "\(Int(weatherRespObj.currently?.uvIndex?.rounded() ?? 0))"
		self.visibilityLabel.text = "\(Int(weatherRespObj.currently?.visibility?.rounded() ?? 0))" + "+ mi"
		self.pressureLabel.text = "\(Int(weatherRespObj.currently?.pressure?.rounded() ?? 0))" + " mb"
		
		// -- reload table view
		self.hourlyTableData = Array(weatherRespObj.hourly?.data.prefix(upTo: 24) ?? [])
		self.hourlyTableView.reloadData()
	}
	
	func getCurrentLocationInfo() {
		locationManager.delegate = self
		locationManager.distanceFilter = kCLDistanceFilterNone
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
		locationManager.requestLocation()

		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
			Utility.showActivityIndicatory(self.view.superview!)
			locationManager.requestLocation()
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
					self.mapDataToUI(weatherRespone: weatherResponse)
				} else if result == .NoInternet {
					Utility.showAlert(self, title: "No Internet", message: NO_NETWORK_ERROR_MSG)
				} else {
					Utility.showAlert(self, title: "Error", message: SERVER_ERROR_MSG)
				}
				Utility.hideActivityIndicatory(self.view.superview!)
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
			
			// -- Network reachability is not yet initialised then wait for a second to call weather info API
			if NetworkReachability.sharedInstance.path == nil {
				_ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
					self.callGetWeatherInfoAPI(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
				})
			} else {
				self.callGetWeatherInfoAPI(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
			}
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		Utility.hideActivityIndicatory(self.view.superview!)
		print(error)
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			manager.requestLocation()
		}
	}
}

// MARK: - UITableView Delegate and data source methods-
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return hourlyTableData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyTableViewCell", for: indexPath) as! HourlyTableViewCell
		cell.configureCell(currentHourData: hourlyTableData[indexPath.row])
        return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 55.0
	}
}
