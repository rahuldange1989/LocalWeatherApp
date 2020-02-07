//
//  ApiManager.swift
//  LocalWeatherApp
//
//  Created by Rahul Dange on 4/10/19.
//  Copyright © 2019 Rahul Dange. All rights reserved.
//

import Foundation

enum RequestResult {
    case Success
    case Fail
    case NoInternet
    case TimeOut
    case Cancel
    case DataError
    case SessionExpired
    case Outdated
    case InvalidLogin
    case ServerError
    case CommonKeyFailed
}

class APIManager {
    
    // -- Get Current Location Weather API
    func getWeatherInfo(latitude: Double, longitude: Double, completion: @escaping (_ weatherReponse: WeatherResponse?, _ result: RequestResult?) -> Void) {
        let url = SERVER_URL + API_KEY_DARK_SKY + "/\(latitude),\(longitude)"

        // -- call and convert data
        self.getJSONFromURL(urlString: url) { (data, result) in
            guard let data = data else {
                print("Failed to get data")
                return completion(nil, result)
            }
            self.createWeatherResponseObjectWith(json: data, completion: { (searchModels, error) in
                return completion(searchModels, error)
            })
        }
    }
}

extension APIManager {
    // -- call get API to receive weather Information
    private func getJSONFromURL(urlString: String, completion: @escaping (_ data: Data?, _ result: RequestResult?) -> Void) {
        if NetworkReachability.sharedInstance.isNetworkAvailable() {
            guard let url = URL(string: urlString) else {
                print("Error: Cannot create URL from string")
                return
            }
            let urlRequest = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
                guard error == nil else {
                    print("Error calling api")
                    return completion(nil, .DataError)
                }
                guard let responseData = data else {
                    print("Data is nil")
                    return completion(nil, .DataError)
                }
                completion(responseData, .Success)
            }
            task.resume()
        } else {
            completion(nil, .NoInternet)
        }
    }
    
    // -- Create SearchArticlesModel from data received using network call
    private func createWeatherResponseObjectWith(json: Data, completion: @escaping (_ data: WeatherResponse?, _ result: RequestResult?) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let searchArticlesModel = try decoder.decode(WeatherResponse.self, from: json)
            return completion(searchArticlesModel, .Success)
        } catch let error {
            print(">>> Error creating current search articles from JSON because: \(error.localizedDescription)")
            return completion(nil, .DataError)
        }
    }
}
