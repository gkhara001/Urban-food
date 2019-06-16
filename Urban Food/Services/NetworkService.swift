//
//  NetworkService.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 18/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import Foundation
import Moya

//#error("Enter a Yelp API key by visiting yelp.com/developers then delete this error.")
private let apiKey = "TQFUojArzg1lS5OuBPs0Ps5ccUzy6Srmst5Oha2dnlumDJxPQlknyobcfcCFPfBU1HjTkCG-KxwfxEScHssoGJ22S5gDKbheMX_IESAlA5-fCfJKpnBjwR_91BnYXHYx"

enum YelpService {
    enum BusinessesProvider: TargetType {
        case search(lat: Double, long: Double)
        case details(id: String)
        
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String {
            switch self {
            case .search:
                return "/search"
            case let .details(id):
                return "/\(id)"
            }
        }
        
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case let .search(lat, long):
                return .requestParameters(
                    parameters: ["latitude": lat, "longitude": long, "limit": 10], encoding: URLEncoding.queryString)
            case .details:
                return .requestPlain
            }
            
        }
        
        var headers: [String : String]? {
            return ["Authorization": "Bearer \(apiKey)"]
        }
    }
}
