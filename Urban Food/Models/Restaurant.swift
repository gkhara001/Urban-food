//
//  Restaurant.swift
//  Urban Food
//
//  Created by Gagansher KHARA on 24/5/19.
//  Copyright © 2019 Gagansher KHARA. All rights reserved.
//

import Foundation

class Restaurant {
    var name: String
    var type: String
    var location: String
    var image: String
    var phone: String
    var restDescription: String
    var isVisited: Bool
    var rating: String
    
    init(name: String, type: String, location: String, image: String, phone: String, restDescription: String, isVisited: Bool, rating: String = "") {
        self.name = name
        self.type = type
        self.location = location
        self.image = image
        self.phone = phone
        self.restDescription = restDescription
        self.isVisited = isVisited
        self.rating = rating
    }
    
    convenience init() {
        self.init(name: "", type: "", location: "", image: "", phone: "", restDescription: "", isVisited: false)
    }
}
