//
//  SettingsViewModel.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import UIKit
import Combine

class SettingsViewModel: ObservableObject {
    
    let privacyPolicyURL : String = "https://sites.google.com/view/controlsfortesla/privacy-policy"
    let ratingUrl: String = "itms-apps://itunes.apple.com/us/app/itunes-u/id1498708644?action=write-review"
    var cancellable: AnyCancellable?
    
    @Published var tempUnitIsC: Bool = UserDefaults.standard.bool(forKey: "tempUnitIsC") {
        willSet {
            UserDefaults.standard.set(newValue, forKey: "tempUnitIsC")
        }
    }
    
    var version: String {
        let main = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0"
        return "\(main) (\(build))"
    }
    
    func goToURL(_ url : String) {
        guard let mUrl = URL(string: url) else { return }
        UIApplication.shared.open(mUrl, options: [:], completionHandler: nil)
    }
    
    @objc func emailFeedback() {
        let email = "whiteboardappdev@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    func logout(_ completion: @escaping (Bool) -> Void) {
        isLoggingOut = true
        cancellable = Logout.send { success in
            if success {
                Debug.log("Logout succeeded")
                DispatchQueue.main.async {
                    self.isLoggingOut = false
                    SecureData.clearKeychain()
                    completion(true)
                }
            } else {
                completion(false)
                Debug.log("Logout failed")
            }
        }
    }
    
    @Published var isLoggingOut: Bool = false
    @Published var shouldShowOnboarding: Bool = false
}
