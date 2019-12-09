//
//  Spot.swift
//  sw754_p2
//
//  Created by Scott Wang on 12/8/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import Foundation


class Spot {
    let id: Int
    let parkType: String
    let occupied: Bool
    let startTime: String
    let endTime: String?
    
    init (id: Int, occupied: Bool, parkType: String, startTime: String, endTime: String) {
        self.id = id
        self.parkType = parkType
        self.occupied = occupied
        self.startTime = startTime
        self.endTime = endTime
    }
}
