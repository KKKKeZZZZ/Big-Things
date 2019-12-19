//
//  BigThing.swift
//  BigThings
//
//  Created by 张珂 on 24/11/19.
//  Copyright © 2019 Ke Zhang. All rights reserved.
//

import Foundation
import UIKit
// big thing class
class BigThing: NSObject{
    // all attributes
    var id: String!
    var name: String! = ""
    var location: String! = ""
    var year: String! = ""
    var status: String! = ""
    var latitude: String! = ""
    var longitude: String! = ""
    var image: UIImage?
    var rating: String! = ""
    var votes: String! = ""
    var descriptions: String! = ""



    var favorite = false

    
    
    override init(){
        
    }
    // constructor with image
    init(id: String, name: String, location: String, year: String, status: String, latitude: String,
         longitude: String, image: UIImage, rating: String, votes: String, descriptions: String) {
        self.id = id
        self.name = name
        self.location = location
        self.year = year
        self.status = status
        self.latitude = latitude
        self.longitude = longitude
        self.location = location
        self.image = image
        self.rating = rating
        self.votes = votes
        self.descriptions = descriptions

        self.favorite = false
    }
    // constrater without image that need use add after creating
    init(id: String, name: String, location: String, year: String, status: String, latitude: String,
         longitude: String, rating: String, votes: String, descriptions: String) {
        self.id = id
        self.name = name
        self.location = location
        self.year = year
        self.status = status
        self.latitude = latitude
        self.longitude = longitude
        self.location = location
        self.rating = rating
        self.votes = votes
        self.descriptions = descriptions
        
        self.favorite = false
    }
    // check if two big thing equal
    override func isEqual(_ object: Any?) -> Bool {
        if let otherBigThing = object as? BigThing {
            if self.id == otherBigThing.id && self.name == otherBigThing.name && self.image!.isEqual(otherBigThing.image) {
                return true
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
}
