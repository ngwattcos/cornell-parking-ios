import UIKit
import Alamofire
import SwiftyJSON

var str = "Hello, playground"
print("potato")


struct ParkingBuildingStruct: Codable {
    let id: Int
    let longName: String
    let total: Int
    let totalEmpty: Int
}

var address = "http://35.243.204.15"
var getAllParkingBuilding = "\(address)/api/buildings"

class NetworkManger {
    static func getLots(_ completion: @escaping ([Any]) -> Void) {
        Alamofire.request(getAllParkingBuilding, method: .get).validate().responseData(completionHandler: {response in
            switch response.result {
            case .success(let data):
                print("success")
            case .failure(let error):
                print(error)
                
            }
        })
    }
}

NetworkManger.getLots({lots in
    print(lots)
})
