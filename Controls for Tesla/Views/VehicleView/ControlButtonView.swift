//
//  ControlButtonView.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 2/20/20.
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
            ZStack {
                RoundedRectangle(cornerRadius: 7)
                .fill(Color.red)
                HStack {
                    Image(systemName: image).font(Font.body.weight(.bold)).foregroundColor(.white)
                    Text(title).fontWeight(.medium).foregroundColor(.white)
                }
            }
        }.buttonStyle(PlainButtonStyle())
            .frame(maxWidth: .infinity, idealHeight: 44.0, maxHeight: 44.0)
            .listRowBackground(Color(UIColor.systemGroupedBackground))
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
