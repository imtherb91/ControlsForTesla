//
//  NetworkActivityModel.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/11/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import SwiftUI

class NetworkActivityModel: NSObject, ObservableObject {
    
    @Published var isWaitingForResponse: Bool = false
    @Published var shouldShowAlert: Bool = false
    @Published var errorMessage: String?
    
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
    
}
