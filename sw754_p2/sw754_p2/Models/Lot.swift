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

class Lot {
    let name: String
    let location: Location
    
    init(name: String, location: Location) {
        self.name = name
        self.location = location
    }
}
