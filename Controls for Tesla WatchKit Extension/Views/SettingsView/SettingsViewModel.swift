//
//  SettingsViewModel.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/9/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var tempUnitIsC: Bool = UserDefaults.standard.bool(forKey: "tempUnitIsC") {
        willSet {
            UserDefaults.standard.set(newValue, forKey: "tempUnitIsC")
        }
    }
    var tempUnit: String {
        tempUnitIsC ? "℃" : "℉"
    }
    var version: String {
        let main = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
        return "\(main) (\(build))"
    }
    @Published var isLoggingOut: Bool = false
    var cancellable: AnyCancellable?
}
