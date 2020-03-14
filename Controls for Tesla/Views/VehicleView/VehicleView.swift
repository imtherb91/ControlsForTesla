//
//  VehicleView.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI
import UIKit

struct VehicleView: View {
    @ObservedObject var model: VehicleViewModel
    @Environment(\.presentationMode) var pres
    var lockButton: some View {
        ControlButtonView(title: model.lock_button_string, image: model.lock_button_image_string) {
            self.model.lockTapped()
        }
    }
    
    var nameStack: some View {
        HStack {
            VStack {
                Text(model.modelYear).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading)
                Text(model.modelName).frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer(minLength: 0.0)
            Text("\(model.vehicle.battery_level)%")
            }.listRowBackground(Color(UIColor.secondarySystemGroupedBackground)).modifier(AddLines())
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
            Alert(title: Text("Are you sure? This will remotely open your front trunk."), primaryButton: Alert.Button.default(Text("Yes"), action: {
                self.model.open(trunk: .front)
            }), secondaryButton: .default(Text("No")))
        }
    }
    
    var trunkButton: some View {
        ControlButtonView(title: "Open Trunk", image: model.trunk_button_image_string) {
            self.model.trunkTapped()
        }.alert(isPresented: $model.openTrunkAlert) { () -> Alert in
            Alert(title: Text("Are you sure? This will remotely open your rear trunk."), primaryButton: Alert.Button.default(Text("Yes"), action: {
                self.model.open(trunk: .rear)
            }), secondaryButton: .default(Text("No")))
        }
    }
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all)
            VStack {
                List {
                    Group {
                        SectionHeaderView(title: "Your Tesla")
                        nameStack
                        Text(model.last_update_full_string).font(.caption).foregroundColor(model.last_update_color).listRowBackground(Color(UIColor.systemGroupedBackground)).frame(maxWidth: .infinity, alignment: .center)
                        SectionHeaderView(title: "Controls")
                        lockButton
                        portButton
                        climateButton
                    }
                    frunkButton
                    trunkButton
                    SectionHeaderView(title: "State")
                    LabelValueRowView(label: "Interior", value: model.inside_temp)
                    LabelValueRowView(label: "Outside", value: model.outside_temp)
                    LabelValueRowView(label: "Climate setting", value: model.driver_temp_setting)
                }.background(Color(UIColor.systemGroupedBackground))
            }
            if model.isWaitingForResponse {
                LoadingView(label: model.loadingLabel)
            }
        }.accentColor(Color.red)
            .navigationBarTitle("\(model.vehicle.display_name ?? "")")
            .navigationBarItems(
                leading:
                Button(action: {
                    self.dismiss()
                }, label: {
                    Image(systemName: "chevron.left").font(Font.body.weight(.bold)).frame(width: 44.0, height: 44.0, alignment: .leading)
                }),
                trailing:
                Button(action: {
                    self.model.getVehicleData(override: true)
                }, label: {
                    Image(systemName: "arrow.clockwise").font(Font.body.weight(.bold)).frame(width: 44.0, height: 44.0, alignment: .center)
                }).disabled(model.isWaitingForResponse)
            )
        .onAppear {
            self.model.getVehicleData()
        }.onDisappear {
            self.model.cancelRequests()
        }.alert(isPresented: $model.shouldShowAlert) { () -> Alert in
            Alert(title: Text(self.model.errorMessage ?? "Error"))
        }
    }
    
    func dismiss() {
        Debug.log()
        self.model.cancelRequests()
        pres.wrappedValue.dismiss()
    }
    
}

struct VehicleView_Previews: PreviewProvider {
    static var previews: some View {
        let v = Vehicle(context: CoreDataHelper.managedContext)
        v.display_name = "K-9"
        v.battery_level = 87
        v.locked = false
        v.vin = "5YJ3E1EA0JF014473"
        v.charge_port_door_open = false
        return NavigationView {
            VehicleView(model: VehicleViewModel(vehicle: v))
        }//.environment(\.colorScheme, .dark)
    }
}
