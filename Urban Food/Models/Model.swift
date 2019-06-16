//
//  Model.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 18/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import Foundation
import CoreLocation

struct Root: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    let id: String
    let name: String
    let imageUrl: URL
    let distance: Double
}

struct RestaurantListViewModel {
    let name: String
    let imageUrl: URL
    let distance: Double
    let id: String
    
    static var numberFormatter: NumberFormatter {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        nf.minimumFractionDigits = 2
        return nf
    }
    
    var formattedDistance: String? {
        return RestaurantListViewModel.numberFormatter.string(from: distance as NSNumber)
    }
}

extension RestaurantListViewModel {
    init(business: Business) {
        self.name = business.name
        self.id = business.id
        self.imageUrl = business.imageUrl
        self.distance = business.distance / 1000.00
    }
}

struct Details: Decodable {
    let price: String
    let phone: String
    let isClosed: Bool
    let rating: Double
    let name: String
    let location: Location
    let photos: [URL]
    let coordinates: CLLocationCoordinate2D
}

struct Location : Codable {
    
    let address1 : String?
    let address2 : String?
    let address3 : String?
    let city : String?
    let country : String?
    let crossStreets : String?
    let displayAddress : [String]?
    let state : String?
    let zipCode : String?
    
    enum CodingKeys: String, CodingKey {
        case address1 = "address1"
        case address2 = "address2"
        case address3 = "address3"
        case city = "city"
        case country = "country"
        case crossStreets = "cross_streets"
        case displayAddress = "display_address"
        case state = "state"
        case zipCode = "zip_code"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address1 = try values.decodeIfPresent(String.self, forKey: .address1)
        address2 = try values.decodeIfPresent(String.self, forKey: .address2)
        address3 = try values.decodeIfPresent(String.self, forKey: .address3)
        city = try values.decodeIfPresent(String.self, forKey: .city)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        crossStreets = try values.decodeIfPresent(String.self, forKey: .crossStreets)
        displayAddress = try values.decodeIfPresent([String].self, forKey: .displayAddress)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        zipCode = try values.decodeIfPresent(String.self, forKey: .zipCode)
    }
    
}

extension CLLocationCoordinate2D: Decodable {
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}


struct DetailsViewModel {
    let name: String
    let price: String
    let isOpen: String
    let phoneNumber: String
    let rating: String
    let imageUrls: [URL]
    let location: Location
    let coordinate: CLLocationCoordinate2D
}

extension DetailsViewModel {
    init(details: Details) {
        self.name = details.name
        self.price = details.price
        self.isOpen = details.isClosed ? "Closed" : "Open"
        self.phoneNumber = details.phone
        self.rating = "★ \(details.rating) / 5.0"
        self.imageUrls = details.photos
        self.location = details.location
        self.coordinate = details.coordinates
    }
    
}

