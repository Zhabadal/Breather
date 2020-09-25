//
//  Models.swift
//  Breather
//
//  Created by Alexandr Badmaev on 25.09.2020.
//  Copyright © 2020 Alexandr Badmaev. All rights reserved.
//

import Foundation

struct CityConditions {
    let city: String
    let weather: Weather
    let pollution: Pollution
    let asthma: Asthma
}

struct Weather {
    let timestamp: String
    let iconCode: String
    let temperature: Int
    let humidity: Int
    let pressure: Int
    let windSpeed: Float
    let windDirection: Int
}

struct Pollution {
    let timestamp: String
    let aqiUS: Int
    let mainPollutantUS: String
    let aqiChina: Int
    let mainPollutantChina: String
}

struct Asthma {
    let risk: String
    let probability: Int
}

extension CityConditions {
    static func sampleData() -> CityConditions {
        let weather = Weather(timestamp: "2019-04-16T11:00:00.000Z",
                              iconCode: "01d",
                              temperature: 5,
                              humidity: 36,
                              pressure: 1015,
                              windSpeed: 9.8,
                              windDirection: 300)
        
        let pollution = Pollution(timestamp: "2019-04-16T18:00:00.000Z",
                                  aqiUS: 9,
                                  mainPollutantUS: "p2",
                                  aqiChina: 3,
                                  mainPollutantChina: "p2")
        
        let asthma = Asthma(risk: "medium",
                            probability: 63)
        
        return CityConditions(city: "New York", weather: weather, pollution: pollution, asthma: asthma)
    }
}

