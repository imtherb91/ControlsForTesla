//
//  LoadingView.swift
//  Key for Tesla Purchases
//
//  Created by Luke Allen on 2/10/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    @State var shouldAnimate = false
    var label: String
    /*
    var oldView: some View {
        HStack {
            Text(label).font(.title)
            Circle()
                .trim(from: 0.0, to: 0.75)
                .stroke(style: StrokeStyle(lineWidth: 7.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.red)
                .rotationEffect(Angle(degrees: shouldAnimate ? 360.0 : 0.0))
                .animation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false)).frame(width: 25.0, height: 25.0).onAppear {
                    self.shouldAnimate = true
            }
        }
    } */
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
            VStack { Icon.image.resizable().frame(width: 80, height: 80).rotationEffect(Angle(degrees: shouldAnimate ? 360.0 : 0.0))
            .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
                Text(label).font(.title).fontWeight(.medium).foregroundColor(Color(UIColor.white))
            }
        }.onAppear {
            self.shouldAnimate = true
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            VehicleView(model: VehicleViewModel(vehicle: Vehicle.fromCodable(VehiclesListResponse.fake().response.first!)))
        //LoadingView(label: "")
        }.environment(\.colorScheme, .light)
    }
}
