//
//  LoadingView.swift
//  Key for Tesla WatchKit Extension
//
//  Created by Luke Allen on 2/9/20.
//  Copyright © 2020 Luke Allen. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    @State var shouldAnimate = false
    var label: String
    /*
    var oldView: some View {
        ZStack { Color.black.opacity(0.7).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                HStack {
                    Text(label)
                    Circle()
                        .trim(from: 0.0, to: 0.75)
                        .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(.red)
                        .rotationEffect(Angle(degrees: shouldAnimate ? 360.0 : 0.0))
                        .animation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false)).frame(width: 15.0, height: 15.0).onAppear {
                            self.shouldAnimate = true
                    }
                }
            }
        }
    } */
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.6).edgesIgnoringSafeArea(.all)
            VStack { Image("PerformanceWheel").resizable().frame(width: 50, height: 50).rotationEffect(Angle(degrees: shouldAnimate ? 360.0 : 0.0))
            .animation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false))
                Text(label).fontWeight(.medium)
            }
        }.onAppear {
            self.shouldAnimate = true
        }
    }
    
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(label: "Refreshing...")
    }
}
