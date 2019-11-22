//
//  Lot.swift
//  sw754_p2
//
//  Created by Scott Wang on 11/19/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import Foundation

enum Location: String {
    case north = "left"
    case central = "tower"
    case west = "right"
}

enum ParkingType: String {
    case general = "general"
    case accessible = "accessible"
    case green = "green"
}

class Lot {
    let name: String
    let location: Location
    let locationString: String
    let availability: Int
    
    init(name: String, location: Location, availability: Int) {
        self.name = name
        self.location = location
        self.availability = availability
        self.locationString = Lot.locationToString(location: location)
    }
    
    static func locationToString(location: Location) -> String {
        switch location {
        case .north:
            return "North"
        case .central:
            return "Central"
        case .west:
            return "West"
        }
        
    }
}
