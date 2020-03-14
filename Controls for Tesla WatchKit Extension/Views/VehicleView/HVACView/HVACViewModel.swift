//
//  HVACViewModel.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/9/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
//import Combine

class HVACViewModel: ObservableObject {
    
    var vehicle: Vehicle
    
    @Published var is_climate_on: Bool = false{
        willSet {
            vehicle.is_climate_on = newValue
        }
    }
    
    @Published var temp_setting: Double = 0.0 {
        willSet {
            vehicle.driver_temp_setting = newValue
            //Not needed - vehicle.passenger_temp_setting = newValue
        }
    }
    
    var farenheit_temp_setting: Double {
        temp_setting * 1.8 + 32.0
    }
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        updateStateValues()
    }
    
    func updateStateValues() {
        is_climate_on = vehicle.is_climate_on
    }
    
    var tempString: String {
        if UserDefaults.standard.bool(forKey: "tempUnitIsC") == true {
            return String(format: "%.1f", self.temp_setting * 1.0)
        } else {
            return String(format: "%.1f", self.farenheit_temp_setting * 1.0)
        }
    }
    
    func decrementTemp() {
        
    }
    
    func incrementTemp() {
        
    }
    
}
