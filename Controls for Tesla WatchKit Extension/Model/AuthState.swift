//
//  AuthState.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import Combine

class AuthState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}
