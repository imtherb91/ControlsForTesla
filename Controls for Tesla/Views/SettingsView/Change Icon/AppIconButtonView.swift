//
//  AppIconButtonView.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 3/3/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct AppIconButtonView: View {
    
    var item: AppIconItem
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            item.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80, alignment: .center)
                .cornerRadius(7)
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(item.isActive ? Color.blue : Color.clear, lineWidth: 4))
        }.buttonStyle(PlainButtonStyle())
    }
}

struct AppIconButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconButtonView(item: AppIconItem(name: "AppIconImage"), action: {})
    }
}
