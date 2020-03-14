//
//  VehiclesView.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/6/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI
import Combine

struct VehiclesView: View {
    
    @ObservedObject var viewModel = VehiclesViewModel(vehicles: [])
    
    var refreshButton: some View {
        Button(action: {
            self.viewModel.getList()
        }) {
            HStack {
                Image(systemName: "arrow.clockwise").font(Font.body.weight(.bold))
                Text("Refresh")
            }.frame(maxWidth: .infinity)
        }
    }
    
    var body: some View {
        ZStack {
            List {
                Section(header: Text("Vehicles")) {
                    if viewModel.isWaitingForResponse && viewModel.vehicles.count == 0 {
                        Text("Loading vehicles...").frame(maxWidth: .infinity, alignment: .center)
                    } else if viewModel.vehicles.count == 0 {
                        refreshButton
                    }
                    ForEach(viewModel.vehicles, id: \.id) { vehicle in
                        NavigationLink(destination: VehicleView(model: VehicleViewModel(vehicle: vehicle))) {
                            VehicleRowView(vehicle: vehicle)
                        }
                    }
                }
                Section {
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings").frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
    }
    
}

struct VehiclesView_Previews: PreviewProvider {
    static var previews: some View {
        VehiclesView()
    }
}
