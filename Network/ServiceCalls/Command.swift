//
//  Command.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/8/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import Combine

class CommandRequest: NetworkRequest {
    
}

class CommandResponse: NetworkResponse {
    var response: CommandBlock?
    
    init(response: CommandBlock) {
        self.response = response
    }
    
    static func fake() -> CommandResponse {
        CommandResponse(response: CommandBlock(result: true, reason: ""))
    }
    
}

class CommandBlock: Codable {
    var result: Bool?
    var reason: String?
    
    init(result: Bool, reason: String) {
        self.result = result
        self.reason = reason
    }
    
}

/// Generic class for calling any of the vehicle commands
class Command {
    static func send(_ vehicle: Vehicle, endpoint: String, completion: @escaping (Bool, String?) -> ()) -> AnyCancellable? {
        let svc = NetworkService<CommandRequest, CommandResponse>(endpoint: endpoint, method: .post)
        return svc.send { response, httpStatus, error in
            completion(response?.response?.result ?? false, response?.response?.reason)
        }
    }
}
