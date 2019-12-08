//
//  LotAvailability.swift
//  sw754_p2
//
//  Created by Scott Wang on 11/24/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import Foundation

class LotAvailability {
    var availability: Int
    var capacity: Int
    var type: ParkingType
    
    init(lotType: ParkingTypeAvailability) {
        self.type = LotAvailability.stringToParkingType(type: lotType.type)
        self.capacity = lotType.capacity
        self.availability = lotType.availability
    }
    
    static func stringToParkingType(type: String) -> ParkingType {
        switch type {
        case "general":
            return ParkingType.general
        case "accessible":
            return ParkingType.accessible
        default:
            return ParkingType.eco
        }
    }
}
