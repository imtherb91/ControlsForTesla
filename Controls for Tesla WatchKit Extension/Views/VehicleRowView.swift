//
//  VehicleRowView.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/6/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct VehicleRowView: View {
    var vehicle: Vehicle
    var body: some View {
        HStack {
            Spacer(minLength: 0.0)
            Image(systemName: "car.fill")
            Text("\(vehicle.display_name ?? "")")
            Spacer(minLength: 0.0)
        }
    }
}

struct VehicleRowView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
        //VehicleRowView(vehicle: Vehicle(display_name: "Test", vehicle_id: 0, id: 0, vin: ""))
    }
}
