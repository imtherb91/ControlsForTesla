//
//  ControlButtonView.swift
//  Controls for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/25/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct ControlButtonView: View {
    var title: String
    var image: String
    var action: () -> Void
    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                Image(systemName: image).font(Font.body.weight(.bold))
                Text(title)
            }.frame(maxWidth: .infinity)
        }.listRowBackground(RoundedRectangle(cornerRadius: 10).fill(Color.darkModeRed))
    }
}

struct ControlButtonView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ControlButtonView(title: "Test", image: "lock.fill") {
                
            }
        }
    }
}
