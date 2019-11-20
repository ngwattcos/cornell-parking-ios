//
//  NetworkManager.swift
//  sw754_p2
//
//  Created by Scott Wang on 11/19/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import Foundation

import Alamofire
import SwiftyJSON

class NetworkManager {
    private static let server = ""
    
    static func getLots(_ completion: @escaping ([Lot]) -> Void) {
        /*
         
         */
        
        // for now, just generate lots manually
        
        let north = Lot(name: "NORTH CC LOT", location: .north)
        let north2 = Lot(name: "NORTH A LOT", location: .north)
        let central = Lot(name: "CENTRAL LOT", location: .central)
        let central2 = Lot(name: "ROCKEFELLER", location: .central)
        let west = Lot(name: "WEST LOT", location: .west)
        let west2 = Lot(name: "BAKER", location: .west)
        
        completion([north, north2, central, central2, west, west2])
    }
}
