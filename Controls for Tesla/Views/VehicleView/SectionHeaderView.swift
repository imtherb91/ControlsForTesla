//
//  SectionHeaderView.swift
//  Controls for Tesla Purchases
//
//  Created by Luke Allen on 2/20/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct SectionHeaderView: View {
    var title: String
    var body: some View {
        Text(title).font(.callout).frame(maxHeight: .infinity, alignment: .bottom).foregroundColor(Color(UIColor.secondaryLabel)).listRowBackground(Color(UIColor.systemGroupedBackground))
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(title: "Test")
    }
}
