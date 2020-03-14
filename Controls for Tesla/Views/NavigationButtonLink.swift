//
//  NavigationButtonLink.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 3/2/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct NavigationButtonLink: View {
    
    var title: String
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            HStack {
                Text(title).foregroundColor(Color(UIColor.label))
                Spacer()
                Image(systemName: "chevron.right").resizable().aspectRatio(contentMode: .fit).foregroundColor(Color(UIColor.systemGray2.withAlphaComponent(0.8))).font(Font.body.weight(.semibold)).frame(width: 12, height: 12, alignment: .trailing)
            }
        }
        
    }
}

struct NavigationButtonLink_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section {
                    NavigationButtonLink(title: "Test", action: {})
                    NavigationLink(destination: Text("Test")) {
                        Text("Test")
                    }
                }.modifier(AddLines())
            }.listStyle(GroupedListStyle()).background(Color(UIColor.systemGroupedBackground))
        }.environment(\.colorScheme, .dark)
    }
}
