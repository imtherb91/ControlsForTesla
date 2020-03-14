//
//  Logout.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/9/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import Combine

class LogoutRequest: NetworkRequest {
    var token: String
    init(token: String?) {
        self.token = token ?? ""
    }
}

class LogoutResponse: NetworkResponse {
    static func fake() -> LogoutResponse {
        LogoutResponse()
    }
}

class Logout {
    class func send(_ completion: @escaping (Bool) -> Void) -> AnyCancellable? {
        let svc = NetworkService<LogoutRequest, LogoutResponse>(endpoint: TeslaPath.revoke, method: .post, request: LogoutRequest(token: SecureData.access_token))
        return svc.send { response, httpStatus, error in
            completion(response != nil)
        }
    }
}
