import UIKit
import Alamofire
import SwiftyJSON


enum Location: String {
    case north = "left"
    case central = "tower"
    case west = "right"
}

class Level {
    let id: Int
    let name: String
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}


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

//
//  Types.swift
//  sw754_p2
//
//  Created by Scott Wang on 12/8/19.
//  Copyright © 2019 Scott Wang. All rights reserved.
//

import Foundation

struct LotStruct: Codable {
    let buildingShortName: String
    let location: String
    let availability: Int
    let capacity: Int
}

struct ParkingTypeAvailability: Codable {
    let type: String
    let availability: Int
    let capacity: Int
}

struct ParkingTypeAvailabilityResponse: Codable {
    let types: [ParkingTypeAvailability]
}

struct GetLotsResponce: Codable {
    let lots: [LotStruct]
}

struct ParkingBuildingStruct: Codable {
    let id: Int
    let longName: String
    let total: Int
    let totalEmpty: Int
}

struct SpotStruct: Codable {
    let id: Int
    let parkType: String    // accessible, general, green
    let emptyFlag: Int
    let startTime: String
    let endTime: String
}

struct LotEntireStruct: Codable {
    let id: Int
    let levelName: String
    let green: Int
    let greenEmpty: Int
    let general: Int
    let generalEmpty: Int
    let accessible: Int
    let accessibleEmpty: Int
    let total: Int
    let totalEmpty: Int
    let spots: [SpotStruct]
}

struct BuildingStruct: Codable {
    let id: Int
    let shortName: String
    let longName: String
    let levels: [LevelStruct]
}

struct BuildingStructSimple: Codable {
    let id: Int
    let longName: String
    let total: Int
    let totalEmpty: Int
}

struct GetAllBuildingResponse: Codable {
    let success: Bool
    let data: [BuildingStructSimple]
}


struct BuildingAvailabilityStruct: Codable {
    let id: Int
    let longName: String
    let accessible: Int
    let accessibleEmpty: Int
    let green: Int
    let greenEmpty: Int
    let general: Int
    let generalEmpty: Int
    let total: Int
    let totalEmpty: Int
}

struct GetBuildingAvailabilityResponse: Codable {
    let success: Bool
    let data: BuildingAvailabilityStruct
}

// used Stack Overflow at
// https://stackoverflow.com/questions/57564740/swift-5-jsondecoder-decode-json-with-field-name-having-a-space-eg-post-title
// to decode JSON keys that have spaces

struct LevelStruct: Codable {
    let name: String
    let levelId: Int
    private enum CodingKeys: String, CodingKey {
        case name = "Level Name"
        case levelId = "Level ID"
    }
}
struct ParkingTypeStruct: Codable {
    let spotId: Int
    let spotName: String
    let levelName: LevelStruct
    let levels: [LevelStruct]
    let spots: [SpotStruct]
}

struct GetAllParkingTypeResponse: Codable {
    let success: Bool
    let data: ParkingTypeStruct
}


var address = "http://35.243.204.15"
var getAllParkingBuilding = "\(address)/api/buildings"
var getAvailability = "\(address)/api/building"

class NetworkManger {
//    static func getLots(_ completion: @escaping ([Lot]) -> Void) {
//        Alamofire.request(getAllParkingBuilding, method: .get).validate().responseData(completionHandler: {response in
//            switch response.result {
//            case .success(let data):
//                let jsonDecoder = JSONDecoder()
//                if let buildingData = try? jsonDecoder.decode(GetAllBuildingResponse.self, from: data) {
//                    print("yay")
//
//                    let buildings = buildingData.data
////                    print(buildings)
//
//                    var lots: [Lot] = []
//
//                    var locations: [Location] = [.north, .central, .west]
//
//                    for i in 0...(buildings.count - 1) {
//
//                        let newLot = Lot(name: buildings[i].longName, location: locations[Int(i/2)], availability: buildings[i].totalEmpty)
//                        lots.append(newLot)
//                    }
//
////                    print(lots)
//                    completion(lots)
//
//                } else {
//                    print("aww")
//                }
////                print("success")
//            case .failure(let error):
//                print(error)
//
//            }
//        })
//    }
    
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
                        levels.append(Level(id: level.levelId, name: level.name))
                    }
                
                    // note: "parktype", "startTime", and "endTime", is missing in the APi call
                    let suggestedSpot = Spot(id: parkingData.data.spotId, occupied: false, parkType: "general", startTime: "", endTime: "")
                    
                    completion(suggestedSpot, spots, levels)
               } else {
                print("wrong format")
            }
                
            case .failure(let error):
                print(error)
            }
        })
    }
}

//NetworkManger.getLots({lots in
//    print(lots)
//})

NetworkManger.getLevels(id: 1, {spot, spots, levels in
    print(spot)
    print(spots)
    print(levels)
})
