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
