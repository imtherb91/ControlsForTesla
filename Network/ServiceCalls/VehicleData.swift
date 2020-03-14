//
//  VehicleData.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/8/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import Combine

class VehicleDataRequest: NetworkRequest {
    
}

class VehicleDataResponse: NetworkResponse {
    var response: VehicleData?
    var error: String?
    
    init(response: VehicleData) {
        fakeSuccess(response)
    }
    
    func fakeError() {
        self.response = nil
        self.error = "Your car is on fire"
    }
    
    func fakeSuccess(_ response: VehicleData) {
        self.response = response
        self.error = nil
    }
    
    static func fake() -> VehicleDataResponse {
        let state = VehicleState(locked: true)
        let config = VehicleConfig(exterior_color: "MetallicBlack")
        let charge = ChargeState(battery_level: 79, battery_range: 265, charge_port_door_open: false, charging_state: "Disconnected")
        let climate = ClimateState(driver_temp_setting: 20.0, inside_temp: 22.0, outside_temp: 25.0, passenger_temp_setting: 20.0, is_climate_on: false)
        let data = VehicleData(vehicle_state: state, vehicle_config: config, charge_state: charge, climate_state: climate)
        return VehicleDataResponse(response: data)
    }
    
}

class VehicleData: Codable {
    var vehicle_state: VehicleState?
    var vehicle_config: VehicleConfig?
    var charge_state: ChargeState?
    var climate_state: ClimateState?
    
    init(vehicle_state: VehicleState, vehicle_config: VehicleConfig, charge_state: ChargeState, climate_state: ClimateState) {
        self.vehicle_state = vehicle_state
        self.vehicle_config = vehicle_config
        self.charge_state = charge_state
        self.climate_state = climate_state
    }
    
}

class VehicleState: Codable {
    var locked: Bool?
    init(locked: Bool) {
        self.locked = locked
    }
}

class VehicleConfig: Codable {
    var exterior_color: String?
    init(exterior_color: String) {
        self.exterior_color = exterior_color
    }
}

class ChargeState: Codable {
    var battery_level: Int16?
    var battery_range: Double?
    var charge_port_door_open: Bool?
    var charging_state: String?
    init(battery_level: Int16, battery_range: Double, charge_port_door_open: Bool, charging_state: String) {
        self.battery_level = battery_level
        self.battery_range = battery_range
        self.charge_port_door_open = charge_port_door_open
        self.charging_state = charging_state
    }
}

class ClimateState: Codable {
    var driver_temp_setting: Double?
    var inside_temp: Double?
    var outside_temp: Double?
    var passenger_temp_setting: Double?
    var is_climate_on: Bool?
    init(driver_temp_setting: Double, inside_temp: Double, outside_temp: Double, passenger_temp_setting: Double, is_climate_on: Bool) {
        self.driver_temp_setting = driver_temp_setting
        self.inside_temp = inside_temp
        self.outside_temp = outside_temp
        self.passenger_temp_setting = passenger_temp_setting
        self.is_climate_on = is_climate_on
    }
}

class VehicleDataHelper {
    static func getData(_ vehicle: Vehicle, completion: @escaping (String?) -> ()) -> AnyCancellable? {
        let svc = NetworkService<VehicleDataRequest, VehicleDataResponse>(endpoint: TeslaPath.vehicle_data(id: vehicle.id), method: .get)
        return svc.send { response, httpStatus, error in
            if let err = response?.error {
                vehicle.last_failed_update = Date()
                completion(err)
                return
            }
            guard let response = response else {
                vehicle.last_failed_update = Date()
                completion("Error getting vehicle data.")
                return
            }
            vehicle.updateFromResponse(response)
            completion(nil)
        }
    }
}
