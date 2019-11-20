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
        let lots: [Lot] = []
        
        let West = Lot(name: "West Lot")
    }
}
