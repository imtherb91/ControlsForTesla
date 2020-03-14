//
//  Icon.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 3/4/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

class Icon {
    static var image: Image {
        UIApplication.shared.alternateIconName == ChangeAppIconModel().standardWheelIcon ? Image("StandardWheel") : Image("PerformanceWheel")
    }
}
