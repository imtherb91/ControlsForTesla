//
//  VehicleRowView.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct VehicleRowView: View {
    var vehicle: Vehicle
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(vehicle.display_name ?? "")")
            Text(vehicle.modelName).foregroundColor(Color(UIColor.systemGray))
        }.listRowBackground(Color(UIColor.secondarySystemGroupedBackground))
    }
}

struct VehicleRowView_Previews: PreviewProvider {
    static var previews: some View {
        let v = Vehicle(context: CoreDataHelper.managedContext)
        v.display_name = "K-9"
        v.vin = "5YJ3E1EA0JF014473"
        return List { VehicleRowView(vehicle: v) }.listStyle(GroupedListStyle())
    }
}
