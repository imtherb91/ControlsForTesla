//
//  ChangeAppIconModel.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 3/3/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import Foundation
import SwiftUI

class ChangeAppIconModel: ObservableObject {
    
    let performanceWheelIcon = "AppIcon"
    let performanceWheelImage = "AppIconImage"
    let standardWheelIcon = "AppIcon2"
    let standardWheelImage = "AppIcon2Image"
    @Published var selectedIconAsset = "AppIconImage"
    
    init() {
        selectedIconAsset = currentIconAsset
    }
    
    var iconStrings: [String] {
        [performanceWheelImage, standardWheelImage]
    }
    
    var iconImages: [Image] {
        iconStrings.map {
            Image($0)
        }
    }
    
    var items: [AppIconItem] {
        iconStrings.map {
            AppIconItem(name: $0)
        }
    }
    
    var currentIcon: String {
        UIApplication.shared.alternateIconName ?? "AppIcon"
    }
    
    var currentIconAsset: String {
        currentIcon == standardWheelIcon ? standardWheelImage : performanceWheelImage
    }
    
    func isSelected(item: AppIconItem) -> Bool {
        item.name == selectedIconAsset
    }
    
    func selectIcon(_ item: AppIconItem) {
        UIApplication.shared.setAlternateIconName(iconForAsset(item.name)) { (error) in
            if let error = error {
                Debug.log(error.localizedDescription)
            } else {
                Debug.log("Success")
                Debug.log("Changed to \(self.iconForAsset(item.name) ?? "Nil")")
                withAnimation {
                    self.selectedIconAsset = self.currentIconAsset
                }
            }
        }
    }
    
    func iconForAsset(_ str: String) -> String? {
        if str == performanceWheelImage {
            return nil
        }
        var new = str
        new.removeLast(5) //Image
        return new
    }
    
}
