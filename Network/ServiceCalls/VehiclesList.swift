//
//  VehiclesListRequest.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/8/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation

class VehiclesListRequest: NetworkRequest {
    // empty GET request
}

class VehiclesListResponse: NetworkResponse {
    let response: [VehicleCodable]
    let count: Int
    
    init(response: [VehicleCodable], count: Int) {
        self.response = response
        self.count = count
    }
    
    static func fake() -> VehiclesListResponse {
        VehiclesListResponse(response: [VehicleCodable.fake()], count: 1)
    }
    
}

class VehicleCodable: Codable {
    let id: Int64?
    let vehicle_id: Int64?
    let vin: String?
    let display_name: String?
    let option_codes: String?
    let color: String?
    let state: String?
    
    init(id: Int64, vehicle_id: Int64, vin: String, display_name: String) {
        self.id = id
        self.vehicle_id = vehicle_id
        self.vin = vin
        self.display_name = display_name
        option_codes = nil
        color = nil
        state = nil
    }
    
    static func fake() -> VehicleCodable {
        VehicleCodable(id: 12345678, vehicle_id: 12345678, vin: "5YJ3E1EA0JF014473", display_name: "Speedy Boi")
    }
    
}
