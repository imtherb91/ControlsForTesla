//
//  HVACView.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct HVACView: View {
    var vehicle: Vehicle
    var model: HVACViewModel!
    
    var climateButton: some View {
        Button(action: {
            
        }) {
            Text("\(model.is_climate_on ? "Turn off" : "Turn on")")
        }
    }
    
    var tempAdjust: some View {
        HStack {
            Button(action: {
                
            }) {
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "arrow.left")
                }
                Text(String(format: "%.1f", model.temp_setting))
                Button(action: {
                    
                }) {
                    Image(systemName: "arrow.right")
                }
                Spacer()
            }
        }
    }
    
    var body: some View {
        VStack {
            climateButton
        }
    }
    
    func toggleClimate() {
        
    }
    
}

struct HVACView_Previews: PreviewProvider {
    static var previews: some View {
        HVACView(vehicle: Vehicle(context: CoreDataHelper.managedContext))
    }
}
