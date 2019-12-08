import UIKit
import Alamofire
import SwiftyJSON


enum Location: String {
    case north = "left"
    case central = "tower"
    case west = "right"
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

struct LevelStruct: Codable {
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

var address = "http://35.243.204.15"
var getAllParkingBuilding = "\(address)/api/buildings"

class NetworkManger {
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
                    
                    for i in 0...(buildings.count - 1) {
                        
                        let newLot = Lot(name: buildings[i].longName, location: locations[Int(i/2)], availability: buildings[i].totalEmpty)
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
}

NetworkManger.getLots({lots in
    print(lots)
})
