//
//  VehiclesViewModel.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 3/7/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class VehiclesViewModel: ObservableObject {
    
    @Published var isWaitingForResponse: Bool = false
    @Published var shouldShowAlert: Bool = false
    @Published var errorMessage: String?
    @Published var vehicles: [Vehicle] = []
    var cancellable: AnyCancellable?
    
    init(vehicles: [Vehicle]) {
        self.vehicles = vehicles
        self.getList()
    }
    
    func shouldHandleError(_ error: Error?) -> Bool {
        if let error = error {
            errorMessage = error.localizedDescription
            shouldShowAlert = true
            return true
        } else {
            return false
        }
    }
    
    func handleError(_ errorString: String) {
        DispatchQueue.main.async {
            self.isWaitingForResponse = false
            self.errorMessage = errorString
            self.shouldShowAlert = true
        }
    }
    
    func getList(_ completion: @escaping () -> Void = {}) {
        isWaitingForResponse = true
        let svc = NetworkService<VehiclesListRequest, VehiclesListResponse>(endpoint: TeslaPath.vehiclesList, method: .get)
        cancellable = svc.send { response, httpStatus, error in
            Debug.log("cancellable: \(self.cancellable == nil ? "Nil" : "Valid")")
            DispatchQueue.main.async {
                withAnimation {
                    self.isWaitingForResponse = false
                    self.vehicles = response?.response.map({ (codable) -> Vehicle in
                        Vehicle.fromCodable(codable)
                    }) ?? []
                }
                _ = self.shouldHandleError(error)
                completion()
            }
        }
    }
    
}
