//
//  AirVisualAPI.swift
//  Breather
//
//  Created by Alexandr Badmaev on 30.09.2020.
//  Copyright © 2020 Alexandr Badmaev. All rights reserved.
//

import Foundation
import Moya

enum AirVisualAPI {
    static private let key = "bf889479-f711-412a-8eff-22630a0c4529"
    
    case nearestCity(lat: Double, lon: Double)
}

extension AirVisualAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.airvisual.com/v2")!
    }
    
    var path: String {
        switch self {
        case .nearestCity: return "/nearest_city"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .nearestCity: return .get
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
        case let .nearestCity(lat, lon):
            let parameters = [
                "lat": String(lat),
                "lon": String(lon),
                "key": AirVisualAPI.key
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
