//
//  AddLines.swift
//  Controls for Tesla
//
//  Created by Luke Allen on 2/24/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct AddLines: ViewModifier {
    func body(content: Content) -> some View {
        content.padding().listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)).overlay(
            VStack {
                Rectangle().frame(height: 1.0).foregroundColor(Color(UIColor.systemGray5)).offset(y: -0.5)
                Spacer()
                Rectangle().frame(height: 1.0).foregroundColor(Color(UIColor.systemGray5)).offset(y: 0.5)
            }
        )
    }
}
