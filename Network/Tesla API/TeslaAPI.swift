//
//  File.swift
//  
//
//  Created by Luke Allen on 12/16/19.
//

import Foundation

struct TeslaAPI {
    static let scheme: String = "https"
    static let host: String = "owner-api.teslamotors.com"
    static let baseUrl: String = "https://owner-api.teslamotors.com"
    static let clientID: String = "81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384"
    static let clientSecret: String = "c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3"
}

struct TeslaPath {
    static let token = "/oauth/token"
    static let revoke = "/oauth/revoke"
    static let vehiclesList = "/api/1/vehicles"
    static func wake(id: Int64) -> String {
        "/api/1/vehicles/\(id)/wake_up"
    }
    static func unlock(id: Int64) -> String {
        "/api/1/vehicles/\(id)/command/door_unlock"
    }
    static func lock(id: Int64) -> String {
        "/api/1/vehicles/\(id)/command/door_lock"
    }
    static func vehicle_data(id: Int64) -> String {
        "/api/1/vehicles/\(id)/vehicle_data"
    }
    static func openChargePort(id: Int64) -> String {
        "/api/1/vehicles/\(id)/command/charge_port_door_open"
    }
    static func closeChargePort(id: Int64) -> String {
        "/api/1/vehicles/\(id)/command/charge_port_door_close"
    }
    static func startHVAC(id: Int64) -> String {
        "/api/1/vehicles/\(id)/command/auto_conditioning_start"
    }
    static func stopHVAC(id: Int64) -> String {
        "/api/1/vehicles/\(id)/command/auto_conditioning_stop"
    }
    static func actuateTrunk(id: Int64) -> String {
        "/api/1/vehicles/\(id)/command/actuate_trunk"
    }
}
