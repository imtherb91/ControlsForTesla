//
//  ChangeAppIconRowView.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 3/3/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct ChangeAppIconRowView: View {
    
    var item: AppIconItem
    var item2: AppIconItem
    var action: () -> Void
    var action2: () -> Void
    
    var itemButton: some View {
        AppIconButtonView(item: item, action: action)
    }
    
    var item2Button: some View {
        AppIconButtonView(item: item2, action: action2)
    }
    
    var body: some View {
        HStack {
            Spacer()
            itemButton
            Spacer()
            item2Button
            Spacer()
        }.listRowBackground(Color.clear)
    }
}

struct ChangeAppIconRowView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeAppIconRowView(item: AppIconItem(name: "AppIconImage"), item2: AppIconItem(name: "AppIcon2Image"), action: {}, action2:{})
    }
}
