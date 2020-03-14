//
//  ContentViewModel.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 2/19/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import Combine

class ContentViewModel: ObservableObject {
    
    @Published var shouldShowOboarding = false
    var cancellable: AnyCancellable?
    
    var onboardingDefaultsValue: Bool {
        UserDefaults.standard.bool(forKey: "hasOnboarded")
    }
    
    init() {
        shouldShowOboarding = !onboardingDefaultsValue
    }
    
    func setOboarded(_ bool: Bool) {
        UserDefaults.standard.set(bool, forKey: "hasOnboarded")
    }
    
}
