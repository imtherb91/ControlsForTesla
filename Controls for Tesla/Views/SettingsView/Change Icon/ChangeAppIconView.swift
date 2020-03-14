//
//  ChangeAppIconView.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 3/3/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct ChangeAppIconView: View {
    
    @ObservedObject var model = ChangeAppIconModel()
    
    var body: some View {
        List {
            ChangeAppIconRowView(item: model.items[0], item2: model.items[1], action: {
                self.model.selectIcon(self.model.items[0])
            }, action2: {
                self.model.selectIcon(self.model.items[1])
            }).modifier(AddLines())
        }.edgesIgnoringSafeArea(.bottom)
            .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitle("Change wheels")
    }
}

struct ChangeAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChangeAppIconView()
        }.navigationViewStyle(DefaultNavigationViewStyle()).environment(\.colorScheme, .light)
    }
}
