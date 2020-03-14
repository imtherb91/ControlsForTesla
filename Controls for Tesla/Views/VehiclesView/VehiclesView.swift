//
//  VehiclesView.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI
import Combine

struct VehiclesView: View {
    @ObservedObject var viewModel: VehiclesViewModel = VehiclesViewModel(vehicles: [])
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Vehicles")) {
                    if viewModel.isWaitingForResponse {
                        Text("Loading vehicles...").frame(maxWidth: .infinity, alignment: .center).modifier(AddLines())
                    }
                    ForEach(viewModel.vehicles, id: \.id) { vehicle in
                        NavigationLink(destination: VehicleView(model: VehicleViewModel(vehicle: vehicle))) {
                            VehicleRowView(vehicle: vehicle)
                        }.modifier(AddLines())
                    }
                }
                Section {
                    NavigationLink(destination: SettingsView()) {
                        Text("Settings").frame(maxWidth: .infinity, alignment: .center)
                    }.modifier(AddLines())
                }
            }.listStyle(GroupedListStyle())
            .navigationBarTitle("Controls for Tesla", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.viewModel.getList()
                }, label: {
                    Image(systemName: "arrow.clockwise").font(Font.body.weight(.bold))
                }).disabled(viewModel.isWaitingForResponse)
            )
            .background(Color(UIColor.systemGroupedBackground))
        }.accentColor(.red).onAppear {
            self.viewModel.getList()
        }.alert(isPresented: $viewModel.shouldShowAlert) { () -> Alert in
            Alert(title: Text(viewModel.errorMessage ?? "Error getting Vehicles list"))
        }
    }
    
}

struct VehiclesView_Previews: PreviewProvider {
    static var previews: some View {
        let vehicle = Vehicle(context: CoreDataHelper.managedContext)
        vehicle.display_name = "Model X"
        return VehiclesView()
    }
}
