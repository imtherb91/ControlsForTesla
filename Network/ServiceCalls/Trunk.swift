//
//  Trunk.swift
//  Key for Tesla
//
//  Created by Luke Allen on 2/17/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import Combine

class TrunkRequest: NetworkRequest {
    init(which_trunk: String) {
        self.which_trunk = which_trunk
    }
    var which_trunk: String
}

class Trunk {
    
    enum Position: String {
        case rear = "rear"
        case front = "front"
    }
    
    static func open(which_trunk: Position, vehicle: Vehicle, completion: @escaping (Bool) -> Void) -> AnyCancellable? {
        let svc = NetworkService<TrunkRequest, CommandResponse>(endpoint: TeslaPath.actuateTrunk(id: vehicle.id), request: TrunkRequest(which_trunk: which_trunk.rawValue))
        return svc.send { (response, httpCode, error) in
            completion(response?.response?.result ?? false)
        }
    }
    
}
