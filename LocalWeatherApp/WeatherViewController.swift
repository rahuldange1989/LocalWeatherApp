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

	let locationManager = CLLocationManager()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.getCurrentLocationInfo()
	}

	// MARK: - Internal methods -
	func getCurrentLocationInfo() {
		locationManager.requestWhenInUseAuthorization()
		
		if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
			print(locationManager.location!)
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
	
	// MARk: - Event handler methods -
}

