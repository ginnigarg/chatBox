//
//  Constants.swift
//  chatBox
//
//  Created by Guneet Garg on 26/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation

struct Constants {
    struct messageFields {
        static let username = "name"
        static let text = "text"
        static let imageURL = "imageurl"
    }
    
    struct Network {
        
        struct OpenWeather{
            static let APIScheme = "http"
            static let APIHost = "api.openweathermap.org"
            static let APIPath = "/data/2.5/weather"
        }
        
        struct ParameterKeys {
            static let latitude = "lat"
            static let longitude = "lon"
            static let APIKEY = "APPID"
        }
        
        struct ParameterValues{
            static let APIKeyValue = ""
        }
        
        struct ResponseKeys {
            static let Weather = "weather"
            static let CityName = "name"
            static let WeatherDescription = "description"
        }
    }
    
}
