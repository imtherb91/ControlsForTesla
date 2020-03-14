//
//  VehicleStateView.swift
//  Key for Tesla
//
//  Created by Luke Allen on 2/17/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct VehicleStateView: View {
    @ObservedObject var model: VehicleViewModel
    
    var lockImage: Image {
        Image(systemName: model.lock_button_image_string)
    }
    
    var lockButton: some View {
        ControlButtonView(title: model.lock_button_string, image: model.lock_button_image_string) {
            self.model.lockTapped()
        }
    }
    
    var nameStack: some View {
        Button(action: {
            self.model.getVehicleData(override: true)
        }) {
            VStack {
                HStack {
                    VStack {
                        Text(model.modelYear).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading)
                        Text(model.modelName).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    Spacer(minLength: 0.0)
                    Text("\(model.vehicle.battery_level)%")
                }
                Text("Tap to refresh").font(.caption).foregroundColor(.gray)
            }
        }
    }
    
    var portButton: some View {
        ControlButtonView(title: model.charge_port_button_string, image: model.charge_port_button_image_string) {
            self.model.chargePortTapped()
        }.alert(isPresented: $model.showUnableClosePortAlert) { () -> Alert in
            Alert(title: Text("Currently plugged in, unable to close port"))
        }
    }
    
    var hvacLink: some View {
        NavigationLink(destination: HVACView(vehicle: model.vehicle)) {
            Text("Climate")
        }
    }
    
    var climateButton: some View {
        ControlButtonView(title: model.climate_button_string, image: "thermometer") {
            self.model.climateTapped()
        }
    }
    
    var frunkButton: some View {
        ControlButtonView(title: "Open Frunk", image: model.frunk_button_image_string) {
            self.model.frunkTapped()
        }.alert(isPresented: $model.openFrunkAlert) { () -> Alert in
            Alert(title: Text("Are you sure? This will remotely open your front trunk."), primaryButton: .default(Text("Yes"), action: {
                self.model.open(trunk: .front)
            }), secondaryButton: .default(Text("No")))
        }
    }
    
    var trunkButton: some View {
        ControlButtonView(title: "Open Trunk", image: model.trunk_button_image_string) {
            self.model.trunkTapped()
        }.alert(isPresented: $model.openTrunkAlert) { () -> Alert in
            Alert(title: Text("Are you sure? This will remotely open your rear trunk."), primaryButton: .default(Text("Yes"), action: {
                self.model.open(trunk: .rear)
            }), secondaryButton: .default(Text("No")))
        }
    }
    
    var body: some View {
        ZStack {
            List {
                Section(header: Text("Your Tesla")) {
                    nameStack
                    Text(model.last_update_full_string).font(.caption).foregroundColor(model.last_update_color).listRowBackground(Color.clear)
                }
                Section(header: Text("Controls")) {
                    lockButton
                    portButton
                    climateButton
                    frunkButton
                    trunkButton
                }
                Section(header: Text("State")) {
                    LabelValueRowView(label: "Interior", value: model.inside_temp)
                    LabelValueRowView(label: "Outside", value: model.outside_temp)
                    LabelValueRowView(label: "Climate setting", value: model.driver_temp_setting)
                }
            }
            
            if model.isWaitingForResponse {
                LoadingView(label: model.loadingLabel)
            }
        }.onAppear {
            self.model.getVehicleData()
        }.alert(isPresented: $model.shouldShowAlert) { () -> Alert in
            Alert(title: Text(self.model.errorMessage ?? "Error"))
        }
    }
}

struct VehicleStateView_Previews: PreviewProvider {
    static var previews: some View {
        let v = Vehicle(context: CoreDataHelper.managedContext)
        v.locked = false
        v.charge_port_door_open = false
        return VehicleStateView(model: VehicleViewModel(vehicle: v))
    }
}
