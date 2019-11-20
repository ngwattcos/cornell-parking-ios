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


struct LotStruct: Codable {
    let buildingShortName: String
    let location: String
    let availability: Int
}

struct GetLotsResponce: Codable {
    let lots: [LotStruct]
}

class NetworkManager {
    private static let server = ""
    
    static func getLots(_ completion: @escaping ([Lot]) -> Void) {
        /*
         
         */
        
        // for now, just generate lots manually
        
        let north = Lot(name: "CC LOT", location: .north, availability: 10)
        let north2 = Lot(name: "A LOT", location: .north, availability: 3)
        let central = Lot(name: "CENTRAL LOT", location: .central, availability: 10)
        let central2 = Lot(name: "RCK LOT", location: .central, availability: 10)
        let west = Lot(name: "WEST MAIN", location: .west, availability: 10)
        let west2 = Lot(name: "BAKER", location: .west, availability: 5)
        
        completion([north, north2, central, central2, west, west2])
    }
}
