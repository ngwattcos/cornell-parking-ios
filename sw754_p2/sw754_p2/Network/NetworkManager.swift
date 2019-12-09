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
    static var getAvailability = "\(address)/api/building"
//    static var getLevels = "\(address)/api/"
    
    static func getLots2(_ completion: @escaping ([Lot]) -> Void) {
        /*

         */

        // for now, just generate lots manually

        completion(loadFakeLots())
    }
    
    static func loadFakeLots() -> [Lot] {
        let north = Lot(name: "CC LOT", location: .north, availability: 10, id: 1)
        let north2 = Lot(name: "A LOT", location: .north, availability: 3, id: 2)
        let central = Lot(name: "CENTRAL LOT", location: .central, availability: 10, id: 3)
        let central2 = Lot(name: "RCK LOT", location: .central, availability: 10, id: 4)
        let west = Lot(name: "WEST MAIN", location: .west, availability: 10, id: 5)
        let west2 = Lot(name: "BAKER", location: .west, availability: 5, id: 6)

        return [north, north2, central, central2, west, west2]
    }
    
    static func getLots(_ completion: @escaping ([Lot]) -> Void) {
        Alamofire.request("\(address)/api/building", method: .get).validate().responseData(completionHandler: {response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                if let buildingData = try? jsonDecoder.decode(GetAllBuildingResponse.self, from: data) {
                    
                    let buildings = buildingData.data
                    
                    var lots: [Lot] = []
                    
                    var locations: [Location] = [.north, .central, .west]
                    
                    for i in 0...(buildings.count - 1) {

                        let newLot = Lot(name: buildings[i].longName, location: locations[Int(i/2) % locations.count], availability: buildings[i].totalEmpty, id: buildings[i].id)
                        lots.append(newLot)
                    }

                    completion(lots)
                    

                } else {
                    print("aww")
                }

            case .failure(let error):
                print(error)
                
                // load fake data when server is not responding?
                completion(loadFakeLots())
                
            }
        })
    }
    
    static func getParkingTypes2(_ completion: @escaping ([ParkingTypeAvailability]) -> Void) {

        let general: ParkingTypeAvailability = ParkingTypeAvailability(type: "general", availability: 10, capacity: 30)

        let accessible: ParkingTypeAvailability = ParkingTypeAvailability(type: "accessible", availability: 10, capacity: 30)

        let eco: ParkingTypeAvailability = ParkingTypeAvailability(type: "eco", availability: 10, capacity: 30)
        
        let response: ParkingTypeAvailabilityResponse = ParkingTypeAvailabilityResponse(types: [general, accessible, eco])
        
        completion(response.types)
        
    }
    
    static func getParkingTypes(id: Int, _ completion: @escaping ([ParkingTypeAvailability]) -> Void) {
        Alamofire.request("\(getAvailability)/\(id)", method: .get).validate().responseData(completionHandler: {response in
            switch response.result {
            case .success(let data):
                print("success")
                
                let jsonDecoder = JSONDecoder()
                if let availabilityData = try? jsonDecoder.decode(GetBuildingAvailabilityResponse.self, from: data) {
                    
                    let availability = availabilityData.data
                    
                    let typeAvailability = [
                        ParkingTypeAvailability(type: "accessible", availability: availability.accessibleEmpty, capacity: availability.accessible),
                        ParkingTypeAvailability(type: "green", availability: availability.greenEmpty, capacity: availability.green),
                        ParkingTypeAvailability(type: "general", availability: availability.generalEmpty, capacity: availability.general),
                    ]
                    
                    completion(typeAvailability)
                }
            case .failure(let error):
                print(error)
            }
        })
            
    }
    
    static func getLevels(id: Int, _ completion: @escaping (Spot, [Spot], [Level]) -> Void) {
        Alamofire.request("\(getAvailability)/\(id)", method: .get).validate().responseData(completionHandler: {response in
            switch response.result {
            case .success(let data):
               print("success")
               
               let jsonDecoder = JSONDecoder()
               if let parkingData = try? jsonDecoder.decode(GetAllParkingTypeResponse.self, from: data) {
                    
                    let spotsData = parkingData.data.spots
                    let levelsData = parkingData.data.levels
                    var levels: [Level] = []
                    var spots: [Spot] = []
                
                    for spot in spotsData {
                        spots.append(Spot(id: spot.id, occupied: spot.emptyFlag == 0, parkType: spot.parkType, startTime: spot.startTime, endTime: spot.endTime))
                    }
                
                    for level in levelsData {
                        levels.append(Level(id: level.levelId, name: level.levelName))
                    }
                
                    // note: "parktype", "startTime", and "endTime", is missing in the APi call
                    let suggestedSpot = Spot(id: parkingData.data.spotId, occupied: false, parkType: "general", startTime: "", endTime: "")
                    
                    completion(suggestedSpot, spots, levels)
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
}
