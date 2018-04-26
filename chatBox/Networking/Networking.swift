//
//  Networking.swift
//  chatBox
//
//  Created by Guneet Garg on 26/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import CoreLocation
class Networking{
    
    static var locationValues = [String]()
    
    func returnDataParameter(userCoordinateAvaliable : CLLocationCoordinate2D) -> [String:String]{
        let data = [Constants.Network.ParameterKeys.APIKEY:Constants.Network.ParameterValues.APIKeyValue,
                    Constants.Network.ParameterKeys.latitude : "\(userCoordinateAvaliable.latitude)",
            Constants.Network.ParameterKeys.longitude : "\(userCoordinateAvaliable.longitude)"]
        return data
    }
    
    func networkSession(userCoordinate : CLLocationCoordinate2D) -> [String]{
        URLSession.shared.dataTask(with: URLMaker(userCoordinate: userCoordinate)) { (data, response, error) in
            if error == nil{
                var parsedResult = [String:AnyObject]()
                DispatchQueue.global().async {
                    do{
                        try? parsedResult = JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
                        let weatherArray = parsedResult[Constants.Network.ResponseKeys.Weather]
                        let weatherDict = weatherArray![0] as! [String:AnyObject]
                        let weatherDescription = weatherDict[Constants.Network.ResponseKeys.WeatherDescription]
                        let city = parsedResult[Constants.Network.ResponseKeys.CityName]
                        Networking.locationValues.append(weatherDescription as! String)
                        Networking.locationValues.append(city as! String)
                        print(Networking.locationValues)
                        NotificationCenter.default.post(name: NSNotification.Name.ValueChanged, object: Networking.locationValues)
                    }
                }
            } else {
                print(error?.localizedDescription as Any)
            }
            }.resume()
        return Networking.locationValues
    }
    
    func URLMaker(userCoordinate : CLLocationCoordinate2D) -> URL{
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Network.OpenWeather.APIScheme
        urlComponents.host = Constants.Network.OpenWeather.APIHost
        urlComponents.path = Constants.Network.OpenWeather.APIPath
        urlComponents.queryItems = [URLQueryItem]()
        for (key,value) in returnDataParameter(userCoordinateAvaliable: userCoordinate){
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(queryItem)
        }
        return urlComponents.url!
    }
    
    func getValues() -> [String]{
        return Networking.locationValues
    }
    
    init() {
    }
}

extension Notification.Name{
    static let ValueChanged = Notification.Name("ValueChanged")
}

