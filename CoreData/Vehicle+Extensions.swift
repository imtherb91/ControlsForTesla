//
//  Vehicle+Extensions.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/8/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import SwiftUI

extension Vehicle {
    
    enum ChargingState {
        case charging
        case disconnected
        case none
    }
    
    
    
    static func fromCodable(_ vehicle: VehicleCodable) -> Vehicle {
        var new: Vehicle
        if let existing = CoreDataHelper.vehicle(withVIN: vehicle.vin) {
            new = existing
        } else {
            new = Vehicle(context: CoreDataHelper.managedContext)
        }
        new.display_name = vehicle.display_name
        new.vehicle_id = vehicle.vehicle_id ?? 0
        new.id = vehicle.id ?? 0
        new.vin = vehicle.vin
        new.locked = true
        new.charge_port_door_open = false
        new.is_climate_on = false
        CoreDataHelper.save()
        return new
    }
    
    func updateFromResponse(_ response: VehicleDataResponse) {
        self.locked = response.response?.vehicle_state?.locked ?? true
        self.exterior_color = response.response?.vehicle_config?.exterior_color
        self.charge_port_door_open = response.response?.charge_state?.charge_port_door_open ?? false
        self.battery_level = response.response?.charge_state?.battery_level ?? 0
        self.battery_range = response.response?.charge_state?.battery_range ?? 0.0
        self.charging_state = response.response?.charge_state?.charging_state
        self.is_climate_on = response.response?.climate_state?.is_climate_on ?? false
        self.driver_temp_setting = response.response?.climate_state?.driver_temp_setting ?? 0.0
        self.passenger_temp_setting = response.response?.climate_state?.passenger_temp_setting ?? 0.0
        self.outside_temp = response.response?.climate_state?.outside_temp ?? 0.0
        self.inside_temp = response.response?.climate_state?.inside_temp ?? 0.0
        self.last_updated = Date()
        self.last_failed_update = nil
        CoreDataHelper.save()
    }
    
    func color() -> Color {
        guard let exterior_color = self.exterior_color else { return .white }
        switch exterior_color {
        case "RedMulticoat":
            return .red
        case "MetallicBlack":
            return .black
        default:
            return .white
        }
    }
    
    var charging_state_enum: ChargingState {
        switch charging_state {
        case "Charging":
            return .charging
        case "Disconnected":
            return .disconnected
        default:
            return .none
        }
    }
    
    var time_since_last_update: TimeInterval? {
        guard let last_updated = last_updated else { return nil }
        return Date().timeIntervalSince(last_updated)
    }
    
    var time_since_last_failed_update: TimeInterval? {
        guard let last_failed = last_failed_update else { return nil }
        return Date().timeIntervalSince(last_failed)
    }
    
    var ten_minutes_since_last_update: Bool {
        guard let time = time_since_last_update else { return true }
        return time > (60.0 * 10.0)
    }
    
    var ten_minutes_since_last_failed_update: Bool {
        guard let time = time_since_last_failed_update else { return true }
        return time > (60.0 * 10.0)
    }
    
    var ten_minutes_since_last_request: Bool {
        return ten_minutes_since_last_update && ten_minutes_since_last_failed_update
    }
    
    var modelName: String {
        guard let vin = vin else { return "" }
        let modelIndex = vin.index(vin.startIndex, offsetBy: 3)
        let model = vin[modelIndex]
        switch model {
        case "S":
            return "Model S"
        case "3":
            return "Model 3"
        case "X":
            return "Model X"
        case "Y":
            return "Model Y"
        case "R":
            return "Roadster"
        default:
            return "Unknown Model"
        }
    }
    
    var modelYear: String {
        guard let vin = vin else { return "" }
        let yearIndex = vin.index(vin.startIndex, offsetBy: 9)
        let year = vin[yearIndex]
        switch year {
        case "A":
            return "2010"
        case "B":
            return "2011"
        case "C":
            return "2012"
        case "D":
            return "2013"
        case "E":
            return "2014"
        case "F":
            return "2015"
        case "G":
            return "2016"
        case "H":
            return "2017"
        case "J":
            return "2018"
        case "K":
            return "2019"
        case "L":
            return "2020"
        case "M":
            return "2021"
        case "N":
            return "2022"
        case "P":
            return "2023"
        default:
            return ""
        }
    }
    
}
