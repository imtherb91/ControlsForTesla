//
//  VehicleViewModel.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class VehicleViewModel: ObservableObject {
    
    // MARK: Activity model stuff
    @Published var isWaitingForResponse: Bool = false
    @Published var shouldShowAlert: Bool = false
    @Published var errorMessage: String?
    
    func handleError(_ errorString: String) {
        DispatchQueue.main.async {
            self.isWaitingForResponse = false
            self.errorMessage = self.sanitizedError(errorString)
            self.shouldShowAlert = true
        }
    }
    
    // END: Activity model stuff
    
    @Published var loadingLabel: String = "Refreshing..."
    @Published var showUnableClosePortAlert: Bool = false
    @Published var openFrunkAlert: Bool = false
    @Published var openTrunkAlert: Bool = false
    @Published var vehicle: Vehicle
    @Published var locked: Bool {
        willSet {
            vehicle.locked = newValue
        }
    }
    @Published var charge_port_door_open: Bool {
        willSet {
            vehicle.charge_port_door_open = newValue
        }
    }
    @Published var is_climate_on: Bool {
        willSet {
            vehicle.is_climate_on = newValue
        }
    }
    
    private var cancellable: AnyCancellable?
    private var workItem: DispatchWorkItem?
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
        self.locked = vehicle.locked
        self.charge_port_door_open = vehicle.charge_port_door_open
        self.is_climate_on = vehicle.is_climate_on
    }
    
    var modelName: String {
        vehicle.modelName
    }
    
    var modelYear: String {
        vehicle.modelYear
    }
    
    var shouldShowFarenheit: Bool {
        !UserDefaults.standard.bool(forKey: "tempUnitIsC")
    }
    
    var adjusted_inside_temp_value: Double {
        if shouldShowFarenheit {
            return vehicle.inside_temp * 1.8 + 32
        } else {
            return vehicle.inside_temp
        }
    }
    
    var adjusted_outside_temp_value: Double {
        if shouldShowFarenheit {
            return vehicle.outside_temp * 1.8 + 32
        } else {
            return vehicle.outside_temp
        }
    }
    
    var adjusted_driver_temp_value: Double {
        if shouldShowFarenheit {
            return vehicle.driver_temp_setting * 1.8 + 32
        } else {
            return vehicle.driver_temp_setting
        }
    }
    
    var inside_temp: String {
        String(format: "%.1fº", adjusted_inside_temp_value)
    }
    
    var outside_temp: String {
        String(format: "%.1fº", adjusted_outside_temp_value)
    }
    
    var driver_temp_setting: String {
        String(format: "%.1fº", adjusted_driver_temp_value)
    }
    
    var last_update_string: String? {
        vehicle.last_updated?.timeDateFormat
    }
    
    var charge_port_button_string: String {
        charge_port_door_open ? "Close port" : "Open port"
    }
    
    var charge_port_button_image_string: String {
        charge_port_door_open ? "bolt.fill" : "bolt.slash.fill"
    }
    
    var lock_button_string: String {
        locked ? "Unlock" : "Lock"
    }
    
    var lock_button_image_string: String {
        locked ? "lock.fill" : "lock.open.fill"
    }
    
    var climate_button_string: String {
        is_climate_on ? "Turn climate off" : "Turn climate on"
    }
    
    var trunk_button_image_string: String {
        "t.circle.fill"
    }
    
    var frunk_button_image_string: String {
        "f.circle.fill"
    }
    
    var last_update_full_string: String {
        if let lastFailed = vehicle.last_failed_update, let lastUpdated = vehicle.last_updated, lastFailed > lastUpdated {
            return "Update failed, please try again."
        } else if let date = last_update_string {
            return "Last update: \(date)"
        } else {
            return "Tap refresh button to update"
        }
    }
    
    // MARK: Vehicle Data
    
    var last_update_color: Color {
        vehicle.last_updated != nil ? Color.gray : Color.red
    }
    
    func updateStateVariables() {
        locked = vehicle.locked
        charge_port_door_open = vehicle.charge_port_door_open
        is_climate_on = vehicle.is_climate_on
    }
    
    // MARK: Service Calls
    
    func getVehicleData(override: Bool = false, completion: @escaping () -> Void = {}) {
        if !vehicle.ten_minutes_since_last_request && !override {
            return
        }
        loadingLabel = "Waking..."
        isWaitingForResponse = true
        wake { success, message in
            guard self.handleWakeResponse(success: success, message: message) else {
                completion()
                return }
            self.requestVehicleData(completion: completion)
        }
    }
    
    func wake(_ completion: @escaping (Bool, String?) -> ()) {
        let svc = NetworkService<CommandRequest, WakeResponse>(endpoint: TeslaPath.wake(id: vehicle.id))
        cancellable = svc.send { (response, httpCode, error) in
            completion(response != nil, error?.localizedDescription)
        }
    }
    
    func handleWakeResponse(success: Bool, message: String?) -> Bool {
        guard success else {
            self.vehicle.last_failed_update = Date()
            self.isWaitingForResponse = false
            self.handleError(message ?? "Error waking")
            return false
        }
        DispatchQueue.main.async {
            withAnimation {
                self.loadingLabel = "Updating..."
            }
        }
        return true
    }
    
    func requestVehicleData(failedCalls: Int = 0, completion: @escaping () -> Void = {}) {
        Debug.log()
        var failed = failedCalls
        self.cancellable = VehicleDataHelper.getData(self.vehicle) { error in
            if error != nil && failed < 5 {
                failed += 1
                self.workItem = DispatchWorkItem {
                    self.requestVehicleData(failedCalls: failed, completion: completion)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5), execute: self.workItem!)
            } else {
                self.handleVehicleDataResponse(error, completion: completion)
            }
        }
    }

    
    func handleVehicleDataResponse(_ error: String?, completion: @escaping () -> Void = {}) {
        DispatchQueue.main.async {
            if let error = error {
                self.handleError(error)
            }
            Debug.log()
            withAnimation {
                self.updateStateVariables()
                self.isWaitingForResponse = false
                completion()
            }
        }
    }

    
    func sendCommand(withLoading lbl: String, endpoint: String, completion: @escaping (Bool) -> Void) {
        self.loadingLabel = lbl
        self.isWaitingForResponse = true
        self.cancellable = Command.send(self.vehicle, endpoint: endpoint) { success, message in
            guard success else {
                self.handleError(message ?? "Command failed")
                completion(false)
                return
            }
            DispatchQueue.main.async {
                withAnimation {
                    completion(true)
                    self.isWaitingForResponse = false
                }
            }
        }
        
    }
    
    func unlock() {
        sendCommand(withLoading: "Unlocking...", endpoint: TeslaPath.unlock(id: vehicle.id)) { success in
            guard success else { return }
            self.locked = false
        }
    }
    
    func lock(_ completion: @escaping (Bool) -> Void = { _ in }) {
        sendCommand(withLoading: "Locking...", endpoint: TeslaPath.lock(id: vehicle.id)) { success in
            guard success else {
                completion(false)
                return
            }
            self.locked = true
            completion(true)
        }
    }
    
    func lockTapped() {
        if vehicle.locked {
            unlock()
        } else {
            lock()
        }
    }
    
    func chargePortTapped() {
        if vehicle.charge_port_door_open {
            if vehicle.charging_state_enum != .disconnected {
                showUnableClosePortAlert = true
                return
            }
            sendCommand(withLoading: "Closing...", endpoint: TeslaPath.closeChargePort(id: vehicle.id)) { status in
                guard status else { return }
                self.charge_port_door_open = false
            }
        } else {
            sendCommand(withLoading: "Opening...", endpoint: TeslaPath.openChargePort(id: vehicle.id)) { status in
                guard status else { return }
                self.charge_port_door_open = true
            }
        }
    }
    
    func climateTapped() {
        if is_climate_on {
            sendCommand(withLoading: "Stopping...", endpoint: TeslaPath.stopHVAC(id: vehicle.id)) { status in
                guard status else { return }
                self.is_climate_on = false
            }
        } else {
            sendCommand(withLoading: "Starting...", endpoint: TeslaPath.startHVAC(id: vehicle.id)) { status in
                guard status else { return }
                self.is_climate_on = true
            }
        }
    }
    
    func frunkTapped() {
        DispatchQueue.main.async {
            self.openFrunkAlert = true
        }
    }
    
    func trunkTapped() {
        DispatchQueue.main.async {
            self.openTrunkAlert = true
        }
    }
    
    func open(trunk: Trunk.Position) {
        DispatchQueue.main.async {
            withAnimation {
                self.loadingLabel = "Opening..."
                self.isWaitingForResponse = true
            }
        }
        cancellable = Trunk.open(which_trunk: trunk, vehicle: self.vehicle) { success in
            Debug.log()
            DispatchQueue.main.async {
                withAnimation {
                    self.loadingLabel = ""
                    self.isWaitingForResponse = false
                    if !success {
                        let trunkStr = trunk == .front ? "frunk" : "trunk"
                        self.handleError("Unable to open \(trunkStr)")
                    }
                }
            }
        }
    }
    
    func sanitizedError(_ err: String) -> String {
        if err.lowercased().contains("vehicle unavailable:") {
            return "Oops! Vehicle unavailable, the update failed. Please try again."
        } else {
            return err
        }
    }
    
    func cancelRequests() {
        Debug.log()
        self.isWaitingForResponse = false
        self.cancellable?.cancel()
        self.workItem?.cancel()
    }
    
}
