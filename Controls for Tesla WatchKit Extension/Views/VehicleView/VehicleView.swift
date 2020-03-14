//
//  VehicleView.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/6/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct VehicleView: View {
    @ObservedObject var model: VehicleViewModel
    
    var lockButton: some View {
        ControlButtonView(title: "Lock", image: "lock.fill") {
            self.model.lock()
        }
    }
    
    var unlockButton: some View {
        ControlButtonView(title: "Unlock", image: "lock.open.fill") {
            self.model.unlock()
        }
    }
    
    var nameStack: some View {
        NavigationLink(destination: VehicleStateView(model: VehicleViewModel(vehicle: model.vehicle))) {
            VStack {
                HStack {
                    Text(model.modelYear).foregroundColor(.gray).frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    
                    Text(model.modelName).frame(maxWidth: .infinity, alignment: .trailing)
                }
                Text("Tap for details").font(.caption).foregroundColor(.gray)
            }
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
                }
                Section(header: Text("Quick Controls")) {
                    unlockButton
                    lockButton
                    frunkButton
                    trunkButton
                }
            }
            if model.isWaitingForResponse {
                LoadingView(label: model.loadingLabel)
            }
        }.alert(isPresented: $model.shouldShowAlert) { () -> Alert in
            Alert(title: Text(model.errorMessage ?? ""))
        }
    }
    
}

struct VehicleView_Previews: PreviewProvider {
    static var previews: some View {
        let v = Vehicle(context: CoreDataHelper.managedContext)
        v.locked = false
        v.charge_port_door_open = false
        return VehicleView(model: VehicleViewModel(vehicle: v))
    }
}
