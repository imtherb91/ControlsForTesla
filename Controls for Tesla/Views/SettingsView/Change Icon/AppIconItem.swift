//
//  AppIconItem.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 3/3/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct AppIconItem: Identifiable {
    var id = UUID()
    var name: String
    var image: Image {
        Image(name)
    }
    var isActive: Bool {
        let isDefault: Bool = name == "AppIconImage"
        var altName: String? = isDefault ? nil : name
        altName?.removeLast(5)
        return UIApplication.shared.alternateIconName == altName
    }
}
