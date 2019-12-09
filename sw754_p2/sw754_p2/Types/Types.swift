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
    let levelName: String
    let levelId: String
    private enum CodingKeys: String, CodingKey {
        case levelName = "Level Name"
        case levelId = "Level ID"
    }
}
struct ParkingTypeStruct: Codable {
    let spotId: Int
    let spotName: String
    let levelName: LevelStruct
}

struct GetAllParkingTypeResponse: Codable {
    let success: Bool
    let data: ParkingTypeStruct
}
