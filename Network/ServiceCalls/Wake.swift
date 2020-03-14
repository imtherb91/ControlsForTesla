//
//  Wake.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/11/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation

class WakeResponse: NetworkResponse {
    var response: WakeResponseObject?
    
    init(response: WakeResponseObject) {
        self.response = response
    }
    
    static func fake() -> WakeResponse {
        WakeResponse(response: WakeResponseObject(id: 12345678, vehicle_id: 12345678))
    }
    
}

class WakeResponseObject: Codable {
    var id: Int64?
    var vehicle_id: Int64?
    
    init(id: Int64, vehicle_id: Int64) {
        self.id = id
        self.vehicle_id = vehicle_id
    }
    
}
