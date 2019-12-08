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
    static var address = "http://35.243.204.15"
    static var getAllParkingBuilding = "\(address)/api/buildings"
    
//    static func getLots(_ completion: @escaping ([Lot]) -> Void) {
//        /*
//
//         */
//
//        // for now, just generate lots manually
//
//        let north = Lot(name: "CC LOT", location: .north, availability: 10)
//        let north2 = Lot(name: "A LOT", location: .north, availability: 3)
//        let central = Lot(name: "CENTRAL LOT", location: .central, availability: 10)
//        let central2 = Lot(name: "RCK LOT", location: .central, availability: 10)
//        let west = Lot(name: "WEST MAIN", location: .west, availability: 10)
//        let west2 = Lot(name: "BAKER", location: .west, availability: 5)
//
//        completion([north, north2, central, central2, west, west2])
//    }
    
    static func getLots(_ completion: @escaping ([Lot]) -> Void) {
            Alamofire.request(getAllParkingBuilding, method: .get).validate().responseData(completionHandler: {response in
                switch response.result {
                case .success(let data):
                    let jsonDecoder = JSONDecoder()
                    if let buildingData = try? jsonDecoder.decode(GetAllBuildingResponse.self, from: data) {
                        print("yay")
                        
                        let buildings = buildingData.data
    //                    print(buildings)
                        
                        var lots: [Lot] = []
                        
                        var locations: [Location] = [.north, .central, .west]
                        
                        let factor = Int(ceil(8.0 / Double(buildings.count)))
                        print(factor)
                        print(factor)
                        print(factor)
                        print(factor)
                        
                        for i2 in 0...(buildings.count * 3 - 1) {
                            let i = i2 % buildings.count
                            
                            let newLot = Lot(name: buildings[i].longName, location: locations[Int(i2/2)], availability: buildings[i].totalEmpty)
                            lots.append(newLot)
                        }
                        
    //                    print(lots)
                        completion(lots)
                        
                    } else {
                        print("aww")
                    }
    //                print("success")
                case .failure(let error):
                    print(error)
                    
                }
            })
        }
    
    static func getParkingTypes(_ completion: @escaping ([ParkingTypeAvailability]) -> Void) {

        let general: ParkingTypeAvailability = ParkingTypeAvailability(type: "general", availability: 10, capacity: 30)

        let accessible: ParkingTypeAvailability = ParkingTypeAvailability(type: "accessible", availability: 10, capacity: 30)

        let eco: ParkingTypeAvailability = ParkingTypeAvailability(type: "eco", availability: 10, capacity: 30)
        
        let response: ParkingTypeAvailabilityResponse = ParkingTypeAvailabilityResponse(types: [general, accessible, eco])
        
        completion(response.types)
        
    }
}
