//
//  LabelValueRowView.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI
import UIKit

struct LabelValueRowView: View {
    var label: String
    var value: String
    #if os(iOS)
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value).foregroundColor(Color(UIColor.secondaryLabel))
            }.listRowBackground(Color(UIColor.secondarySystemGroupedBackground)).modifier(AddLines())
    }
    #elseif os(watchOS)
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
    }
    #endif
}

struct LabelValueRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Section {
                LabelValueRowView(label: "Interior", value: "69º")
            }
        }//.listStyle(GroupedListStyle())
    }
}
